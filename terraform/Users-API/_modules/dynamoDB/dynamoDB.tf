resource "aws_dynamodb_table" "Users" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  hash_key       = "id"
  read_capacity  = 20 # Must be configured
  write_capacity = 20 # Must be configured
  enable_POITB = false

  attribute {
    name = "id"
    type = "N"
  }

  # Must be specified
  tags = {
    Name        = "Users-Table"
    Environment = "sandbox"
  }
}


