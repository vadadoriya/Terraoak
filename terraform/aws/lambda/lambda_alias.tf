resource "aws_lambda_alias" "foo_lambda" {
  # All options # Must be configured
  name             = "foo"
  description      = "an alias for our foo function"
  function_name    = aws_lambda_function.foo.arn
  function_version = "$LATEST"

  # Conflicts with latest function version
  # routing_config {
  #   additional_version_weights = {
  #     "2" = 0.5
  #   }
  # }
}

resource "aws_lambda_provisioned_concurrency_config" "example" {
  # All options # Must be configured
  function_name                     = aws_lambda_function.foo.function_name
  qualifier                         = aws_lambda_function.foo.version
  provisioned_concurrent_executions = 100
}

resource "aws_lambda_event_source_mapping" "example" {
  # All options # Must be configured
  event_source_arn = aws_sqs_queue.foo_lambda.arn
  function_name    = aws_lambda_function.foo.arn

  # Applies in case of dynamoDB or kinesis as event_source_arn
  # destination_config {
  #   on_failure {
  #     destination = aws_sqs_queue.foo_lambda.arn
  #   }
  # }
}
