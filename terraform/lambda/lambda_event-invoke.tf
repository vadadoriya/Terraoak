resource "aws_lambda_function_event_invoke_config" "lambda_invoke_config" {
  # All options # Must be configured
  function_name                = aws_lambda_alias.foo_lambda.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
  qualifier                    = "$LATEST"

  destination_config {
    on_failure {
      destination = aws_sqs_queue.foo_lambda.arn
    }

    on_success {
      destination = aws_sns_topic.foo_lambda.arn
    }
  }
}
