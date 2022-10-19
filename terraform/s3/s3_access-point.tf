resource "aws_s3_access_point" "foo" {
  bucket = aws_s3_bucket.foo.id # Must be configured
  name   = "foo"

  public_access_block_configuration {
    # All options # Must be configured
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }

  vpc_configuration {
    vpc_id = aws_vpc.s3.id # Must be configured
  }
}
