resource "aws_dynamodb_table" "foo" {
  name           = "foo"
  billing_mode   = "PROVISIONED"
  hash_key       = "UserId"
  range_key      = "GameTitle"
  read_capacity  = 10 # Must be configured
  write_capacity = 10 # Must be configured

  # stream_enabled   = true
  # stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  point_in_time_recovery {
    # SaC Testing - Severity: Critical - Set point_in_time_recovery.enabled to false
    enabled = false # Must be configured
  }

  timeouts {
    create = "10m"
    delete = "10m"
    update = "1h"
  }

  global_secondary_index {
    name               = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    read_capacity  = 0 # Must be configured
    write_capacity = 0 # Must be configured
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  server_side_encryption {
    enabled     = false
    kms_key_arn = "" # Must be configured
  }

  # Must be specified
  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}

