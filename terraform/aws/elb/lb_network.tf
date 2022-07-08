resource "aws_lb" "network" {
  # All options # Must be configured
  name_prefix                      = "bar"
  internal                         = false
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
  # subnets                          = aws_subnet.application.*.id

  # Applicable when internal is true
  # subnet_mapping {
  #   subnet_id            = aws_subnet.application.id
  #   private_ipv4_address = "10.20.3.15"
  # }

  subnet_mapping {
    subnet_id     = aws_subnet.application.id
    allocation_id = aws_eip.bar.id
  }


  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  # All options # Must be configured
  load_balancer_arn = aws_lb.network.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network.arn
  }
}

resource "aws_lb_target_group" "network" {
  # All options # Must be configured
  name        = "foo-tg-network-lb"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.foo_lb.id
}

resource "aws_lb_listener" "back_end" {
  # All options # Must be configured
  load_balancer_arn = aws_lb.network.arn
  port              = "8082"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08" # Must be configured
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network.arn
  }
}
