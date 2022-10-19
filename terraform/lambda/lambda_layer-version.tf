resource "aws_lambda_layer_version" "lamda_layer_version" {
  
  # All options # Must be configured
  layer_name          = "bar_lamda"
  description         = "Provide a security layer on top"
  compatible_runtimes = ["nodejs12.x"]
  s3_bucket           = aws_s3_bucket.foo.id
  # SaC Testing - Severity: High - Set s3_key to ""
  s3_key              = ""
  s3_object_version   = aws_s3_bucket_object.bar_file_upload.version_id
  # filename            = data.archive_file.bar.output_path # Conflicts with s3_object_version
}

resource "aws_lambda_layer_version_permission" "lambda_layer_version_permission" {
  layer_name     = aws_lambda_layer_version.bar_lamda.layer_name
  version_number = 1
  # SaC Testing - Severity: Critical - Set principal to * 
  principal      = "*"
  # SaC Testing - Severity: Critical - Set action to ""
  action         = ""
  statement_id   = "dev-account"
}

data "archive_file" "bar" {
  type        = "zip"
  source_file = "${path.module}/foo/bar.js"
  output_path = "${path.module}/foo/bar.zip"
}
