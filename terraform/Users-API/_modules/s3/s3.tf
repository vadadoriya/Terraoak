resource "aws_s3_bucket" "lambda_bucket" {
  bucket =  "terraform-webinar-demo-files"

  force_destroy = true
}

resource "aws_s3_object" "lambda_users_get" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "user-store-get.zip"
  source = var.source_getusers
  etag = var.etagGetUsers
}

resource "aws_s3_object" "lambda_users_set" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "user-store-set.zip"
  source = var.sourcec_setusers
  etag = var.etagSetUsers
}
