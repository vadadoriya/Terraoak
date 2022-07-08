resource "aws_lb" "application" {
  # All options # Must be configured
  name_prefix        = "foo"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.application.id, aws_subnet.backup.id]
  security_groups    = [aws_security_group.bar.id]
  idle_timeout       = 60
  # Prefered value True
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  ip_address_type                  = "ipv4"
  drop_invalid_header_fields       = true

  access_logs {
    # All options # Must be configured
    bucket = aws_s3_bucket.foo_lb_logs.bucket
    prefix = "foo-lb"
    # Preferred value true
    enabled = true
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "application" {
  load_balancer_arn = aws_lb.application.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    # All options # Must be configured
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "authenticate" {
  # All options # Must be configured
  load_balancer_arn = aws_lb.application.arn
  port              = "8082"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  # This example is based on oidc based authentication User can use coginito config as well
  default_action {
    type = "authenticate-oidc"

    authenticate_oidc {
      authentication_request_extra_params = {
        "foo" = "bar"
      }
      # Preferred value authenticate, deny
      on_unauthenticated_request = "deny"
      session_cookie_name        = "foo"
      session_timeout            = 300
      client_id                  = var.client_id
      client_secret              = var.client_secret
      issuer                     = "https://oak9.okta.com/oauth2/default"
      token_endpoint             = "https://oak9.okta.com/oauth2/default/v1/token"
      authorization_endpoint     = "https://oak9.okta.com/oauth2/default/v1/authorize"
      user_info_endpoint         = "https://oak9.okta.com/oauth2/default/v1/userinfo"
    }
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application.arn
  }
}

resource "aws_lb_listener_certificate" "foo" {
  # All options # Must be configured
  listener_arn    = aws_lb_listener.authenticate.arn
  certificate_arn = var.certificate_arn
}

resource "aws_lb_target_group" "application" {
  name = "foo-application"
  port = 443
  # Preferred value HTTPS for application & TLS for network
  protocol                           = "HTTPS"           # Must be configured
  target_type                        = "instance"        # Must be configured
  vpc_id                             = aws_vpc.foo_lb.id # Must be configured
  load_balancing_algorithm_type      = "round_robin"     # Must be configured
  slow_start                         = 35
  lambda_multi_value_headers_enabled = false
  # Preferred value true
  proxy_protocol_v2 = false # Must be configured
  # Preferred value less than 60
  deregistration_delay = 300 # Must be configured

  health_check {
    # All options # Must be configured
    enabled           = true
    healthy_threshold = 3
    interval          = 30
    # Preferred value HTTPS for application & TLS for network
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
    path                = "/health"
    port                = 80
    matcher             = "200,202"
  }

  stickiness {
    # All options # Must be configured
    cookie_duration = 86400
    enabled         = true
    type            = "lb_cookie"
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "backup" {
  name                 = "bar-application"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 10
  vpc_id               = aws_vpc.foo_lb.id
}

resource "aws_lb_target_group_attachment" "foo" {
  # All options # Must be configured
  target_group_arn  = aws_lb_target_group.backup.arn
  target_id         = "10.20.3.16"
  port              = 80
  availability_zone = "us-east-2a"
}

resource "aws_lb_listener_rule" "forward" {
  listener_arn = aws_lb_listener.application.arn # Must be configured
  priority     = 99


  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.application.arn
        weight = 80
      }

      target_group {
        arn    = aws_lb_target_group.backup.arn
        weight = 100
      }
      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }

  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }

  condition {
    host_header {
      values = ["foo.example.com"] # Must be configured
    }
  }

  condition {
    http_header {
      http_header_name = "X-Forwarded-For" # Must be configured
      values           = ["192.168.1.*"]
    }
  }

  condition {
    source_ip {
      values = ["10.20.3.0/24"]
    }
  }
}

resource "aws_lb_listener_rule" "redirect" {
  listener_arn = aws_lb_listener.application.arn

  action {
    type  = "redirect"
    order = 1

    redirect {
      host = "#{host}"
      path = "/#{path}"
      port = "443" # Must be configured
      # Preferred value HTTPS
      protocol    = "HTTPS" # Must be configured
      status_code = "HTTP_301"
      query       = "#{query}"
    }
  }

  condition {
    http_header {
      http_header_name = "X-Forwarded-For"
      values           = ["192.168.1.*"]
    }
  }

  condition {
    query_string {
      key   = "health"
      value = "check"
    }

    query_string {
      value = "bar"
    }
  }

  condition {
    http_request_method {
      values = ["GET", "POST"]
    }
  }
}
