resource "aws_s3_bucket_policy" "foo" {
  # All options # Must be configured
  bucket = aws_s3_bucket.foo.id

  # Terraform's "jsonencode" function converts a Terraform expression's result to valid JSON syntax.
  # SaC Testing - Severity: Critical - Set Policy to ""
  policy = ""
}