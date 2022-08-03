resource "aws_dynamodb_table" "Pets" {
  name           = "foo"
  billing_mode   = "PROVISIONED"
  hash_key       = "id"
  read_capacity  = 20 # Must be configured
  write_capacity = 20 # Must be configured

  attribute {
    name = "id"
    type = "N"
  }

  attribute {
    name = "breed"
    type = "S"
  }

  attribute {
    name = "gender"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "owner"
    type = "S"
  }

  attribute {
    name = "birthday"
    type = "N"
  }

  # Must be specified
  tags = {
    Name        = "Pets-Table"
    Environment = "dev"
  }
}


