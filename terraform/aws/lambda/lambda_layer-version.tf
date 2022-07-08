resource "aws_lambda_layer_version" "bar_lamda" {
  # All options # Must be configured
  layer_name          = "bar_lamda"
  description         = "Provide a security layer on top"
  compatible_runtimes = ["nodejs12.x"]
  s3_bucket           = aws_s3_bucket.foo.id
  s3_key              = aws_s3_bucket_object.bar_file_upload.key
  s3_object_version   = aws_s3_bucket_object.bar_file_upload.version_id
  # filename            = data.archive_file.bar.output_path # Conflicts with s3_object_version
}

data "archive_file" "bar" {
  type        = "zip"
  source_file = "${path.module}/foo/bar.js"
  output_path = "${path.module}/foo/bar.zip"
}

resource "aws_s3_bucket_object" "bar_file_upload" {
  bucket = aws_s3_bucket.foo.id
  key    = "bar.zip"
  source = data.archive_file.bar.output_path
}
