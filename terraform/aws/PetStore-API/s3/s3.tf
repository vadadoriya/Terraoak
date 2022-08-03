resource "random_pet" "lambda_bucket_name" {
  prefix = "learn-terraform-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
}

data "archive_file" "lambda_pets_get" {
  type = "zip"

  source_dir  = "${path.module}/python/pet-get.py"
  output_path = "${path.module}/pet-store-get.zip"
}

data "archive_file" "lambda_pets_set" {
  type = "zip"

  source_dir  = "${path.module}/python/pet-set.py"
  output_path = "${path.module}/pet-store-set.zip"
}

resource "aws_s3_object" "lambda_pets_get" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "pet-store-get.zip"
  source = data.archive_file.lambda_pets_get.output_path

  etag = filemd5(data.archive_file.lambda_pets_get.output_path)
}

resource "aws_s3_object" "lambda_pets_set" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "pet-store-set.zip"
  source = data.archive_file.lambda_pets_set.output_path

  etag = filemd5(data.archive_file.lambda_pets_set.output_path)
}
