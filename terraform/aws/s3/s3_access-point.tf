resource "aws_s3_access_point" "foo" {
  bucket = aws_s3_bucket.foo.id # Must be configured
  name   = "foo"

  public_access_block_configuration {
    # All options # Must be configured
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  vpc_configuration {
    vpc_id = aws_vpc.s3.id # Must be configured
  }
}

resource "aws_vpc" "s3" {
  cidr_block = "10.0.0.0/16"
}
