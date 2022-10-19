resource "aws_s3_access_point" "foo" {
  bucket = aws_s3_bucket.foo.id # Must be configured
  name   = "foo"

  public_access_block_configuration {
    # All options # Must be configured
    # SaC Testing - Severity: Critical - Set block_public_acls to false
    block_public_acls       = false
    # SaC Testing - Severity: Critical - Set block_public_policy to false
    block_public_policy     = false
    # SaC Testing - Severity: Critical - Set ignore_public_acls to false
    ignore_public_acls      = false
    # SaC Testing - Severity: Critical - Set restrict_public_buckets to false
    restrict_public_buckets = false
  }

  vpc_configuration {
    vpc_id = aws_vpc.s3.id # Must be configured
  }
}
