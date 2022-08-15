resource "aws_lambda_function" "UsersGet" {
  function_name = "Petstore-Get"


  s3_bucket = "terraform-webinar-demo-files"
  s3_key    = "user-store-get.zip"

  runtime = "python3.9"
  handler = "lambda.handler"

  source_code_hash = var.source_code_hash_get
  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "UsersSet" {
  function_name = "Petstore-Set"

  s3_bucket = "terraform-webinar-demo-files"
  s3_key =  "user-store-set.zip"


  runtime = "python3.9"
  handler = "lambda.handler"

  source_code_hash = var.source_code_hash_set

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "lambdaUsersApi" {
  name = "/aws/lambda/LambdaUsersApi"

  retention_in_days = 30
}



resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2022-07-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
