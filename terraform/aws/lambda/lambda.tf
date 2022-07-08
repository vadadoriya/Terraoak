resource "aws_lambda_function" "foo" {
  # All options # Must be configured
  function_name                  = "function_foo"
  handler                        = "index.handler"
  timeout                        = 180
  runtime                        = "nodejs12.x"
  publish                        = true
  package_type                   = "Zip"
  memory_size                    = 128
  reserved_concurrent_executions = -1
  # Must be configured # Conflicts with image_uri, filename
  s3_bucket                      = aws_s3_bucket.foo.id
  s3_key                         = aws_s3_bucket_object.foo_file_upload.key
  s3_object_version              = aws_s3_bucket_object.foo_file_upload.version_id
  role                           = aws_iam_role.foo_lambda.arn
  kms_key_arn                    = aws_kms_key.foo_lambda.arn
  source_code_hash               = filebase64sha256(data.archive_file.foo.output_path)
  # Must be configured # Conflicts with s3_bucket, s3_key, s3_object_version, image_uri 
  # filename                       = "lambda_function_payload.zip"
  # Must be configured # Conflicts with filename, s3_bucket, s3_key, s3_object_version 
  # image_uri                      = "ami-0277b52859bac6f4b" 

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.foo_lambda.id]
    security_group_ids = [aws_security_group.foo_lambda.id]
  }
  environment {
    variables = {
      foo = "bar"
    }
  }

  description = "A lambda function for demonstration" # Must be configured

  # Must be present
  tags = {
    Name = "foo function"
  }
}

resource "aws_s3_bucket" "foo" {
  bucket_prefix = "foo"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Name = "My foo bucket"
  }
}

data "archive_file" "foo" {
  type        = "zip"
  source_file = "${path.module}/foo/index.js"
  output_path = "${path.module}/foo/foo.zip"
}

resource "aws_s3_bucket_object" "foo_file_upload" {
  bucket = aws_s3_bucket.foo.id
  key    = "foo.zip"
  source = data.archive_file.foo.output_path
}
resource "aws_cloudwatch_log_group" "foo" {
  name_prefix       = "foo"
  retention_in_days = 14
}

resource "aws_kms_key" "foo_lambda" {
  description              = "KMS key to encrypt/decrypt lambda code"
  deletion_window_in_days  = 10
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  is_enabled               = true
}
