resource "aws_lb" "application" {
  # All options # Must be configured
  name_prefix        = "foo"
  # SaC Testing - Severity: Critical - Set internal to false 
  internal           = false
  # SaC Testing - Severity: High - Set load_balancer_type to ""
  load_balancer_type = ""
  subnet_mapping {
    # SaC Testing - Severity: High - Set subnet_id to ""
    subnet_id = ""
  }
  # SaC Testing - Severity: High - Set subnet to [""]
  subnets            = [""]
  # SaC Testing - Severity: Critical - Set security_groups to ""
  security_groups    = [""]
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

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_lb.application.arn
  
  port              = "80"
  # SaC Testing - Severity: critical - Set protocol to ""
  protocol          = "HTTP"
  # SaC Testing - Severity: critical - Set protocol to ""
  ssl_policy = ""

  default_action {
    # All options # Must be configured
    type = "redirect"

    # SaC Testing - Severity: Critical - Set redirect to undefined
    redirect {
      status_code = "HTTP_301"
      # SaC Testing - Severity: High - Set port != 443
      port = "443"
      # SaC Testing - Severity: High - Set protocol != https
      protocol = "HTTPS"
    }

    authenticate_cognito {
      # SaC Testing - Severity: High - Set user_pool_arn to ""
      user_pool_arn = ""
    }


  }
}

resource "aws_lb_listener_rule" "redirect-rule" {
  listener_arn = aws_lb_listener.application.arn

  action {
    type  = "redirect"
    order = 1
    # SaC Testing - Severity: Critical - Set redirect to undefined
    redirect {
      host = "#{host}"
      path = "/#{path}"
      # SaC Testing - Severity: Critical - Set port != 443
      port = "443" # Must be configured
      # SaC Testing - Severity: Critical - Set protocol != https
      protocol    = "HTTPS" # Must be configured
      status_code = "HTTP_301"
      query       = "#{query}"
    }
  }
}