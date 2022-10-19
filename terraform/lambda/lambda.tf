resource "aws_lambda_function" "oak9_lambda" {
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
  #SaC Testing - Severity: Critical - Set role to ""
  role                           = ""
  kms_key_arn                    = aws_kms_key.foo_lambda.arn
  #SaC Testing - Severity: High - Set source_code_hash to ""
  source_code_hash               = ""
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
    # SaC Testing - Severity: Critical - Set security_group_ids to ""
    security_group_ids = [""]
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

data "archive_file" "foo" {
  type        = "zip"
  source_file = "${path.module}/foo/index.js"
  output_path = "${path.module}/foo/foo.zip"
}



