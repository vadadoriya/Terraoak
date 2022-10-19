resource "aws_wafv2_ip_set" "ip_set_demo" {
  name               = "ip_set_demo"
  description        = "Example IP set"
  
#   Valid values are CLOUDFRONT or REGIONAL
  scope              = "REGIONAL"
#   Valid values are IPV4 or IPV6.
  ip_address_version = "IPV4"
  # SaC Testing - Severity: High - Set addresses to ['0.0.0.0']
  addresses          = ["0.0.0.0", "5.6.7.8/32"]

  tags = {
    Name = "ip_set_demo"
    Environment = "dev"
  }
}


resource "aws_wafv2_rule_group" "wafv2_rule_demo" {
  name     = "wafv2_rule_demo"
  scope    = "REGIONAL"
  capacity = 2

  rule {
    name     = "rule-1"
    priority = 1

    action {
      allow {}
    }

    statement {

      geo_match_statement {
        country_codes = ["US", "NL"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl" "wafv2_web_acl_demo" {
  name        = "managed-rule-example"
  description = "Example of a managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        excluded_rule {
          name = "SizeRestrictions_QUERYSTRING"
        }

        excluded_rule {
          name = "NoUserAgent_HEADER"
        }

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "NL"]
          }
        }
      }
    }

    visibility_config {
      # SaC Testing - Severity: High - Set cloudwatch_metrics_enabled to t
      cloudwatch_metrics_enabled = true
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}



