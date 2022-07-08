resource "aws_s3_bucket_policy" "foo" {
  # All options # Must be configured
  bucket = aws_s3_bucket.foo.id

  # Terraform's "jsonencode" function converts a Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:DeleteBucket"
        Resource = [
          aws_s3_bucket.foo.arn,
          "${aws_s3_bucket.foo.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "8.8.8.8/32"
          }
        }
      },
    ]
  })
}