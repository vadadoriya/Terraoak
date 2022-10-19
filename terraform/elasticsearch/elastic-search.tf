
resource "aws_elasticsearch_domain" "es" {
  domain_name = local.elk_domain
  elasticsearch_version = "7.10"

  log_publishing_options {
    # SaC Testing - Severity: High - Set log_publishing_options.enabled to false
    enabled = false
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }
  node_to_node_encryption {
    # SaC Testing - Severity: Critical - Set node_to_node_encryption.enabled to false
    enabled = false
  }

  cognito_options {
    # SaC Testing - Severity: High - Set cognito_options.enabled to false
    enabled = false
    # SaC Testing - Severity: High - Set cognito_options.role_arn to ""
    role_arn = ""
  }

  cluster_config {
      dedicated_master_enabled = true
      instance_count = 3
      instance_type = "r5.large.elasticsearch"
      # SaC Testing - Severity: High - Set zone_awareness_enabled to false
      zone_awareness_enabled = false
      zone_awareness_config {
        # SaC Testing - Severity: High - Set availability_zone_count to 0 
        availability_zone_count = 0
      }
  }

  domain_endpoint_options {
    # SaC Testing - Severity: Critical - Set domain_endpoint_options.tls_security_policy to ""
    tls_security_policy = ""
    # SaC Testing - Severity : Critical - Set domain_endpoint_options.enforce_https to false
    enforce_https                   = false
    custom_endpoint_enabled         = false
    # custom_endpoint                 = "okta.com"
    # custom_endpoint_certificate_arn = "arn:aws:acm:us-east-2:709695003849:certificate/43b842f7-7ab8-466f-b735-950b023206aa"
  }

  vpc_options {
      # SaC Testing - Severity: High - Set subnet_ids to [""]
      subnet_ids = [""]

      # SaC Testing - Severity: Critical - Set security_group_ids to [""]
      security_group_ids = [""]
  }

  ebs_options {
      ebs_enabled = true
      volume_size = 10
  }

  encrypt_at_rest {
    # SaC Testing - Severity: Critical - Set encryption.enabled to false
    enabled    = false
    kms_key_id = ""
  }
  
  advanced_security_options {
    enabled                        = true
    # SaC Testing - Severity: Critical - Set internal_user_database_enabled to true
    internal_user_database_enabled = true
    master_user_options {
      master_user_arn      = ""
      master_user_name     = var.username
      master_user_password = var.password
    }
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
     
     {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["es.amazonaws.com"]
      },
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.elk_domain}/*"
      }     
  ]
}
  CONFIG

  snapshot_options {
      automated_snapshot_start_hour = 23
  }

  tags = {
      Domain = local.elk_domain
  }
}


