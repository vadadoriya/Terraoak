output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.UsersGet.function_name
}

output "lambda_arn_UsersGet" {
  value = aws_lambda_function.UsersGet.arn
  sensitive = true
} 

output "lambda_arn_UsersSet" {
  value = aws_lambda_function.UsersSet.arn
  sensitive = true
} 