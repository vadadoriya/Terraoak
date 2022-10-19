resource "aws_iam_role" "foo_lambda" {
  name = "foo_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_logging_foo" {
  name        = "foo_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
        "Action": [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        "Resource": "${aws_sqs_queue.foo_lambda.arn}",
        "Effect": "Allow"
    },
    {
        "Action": [
          "sns:Publish"
        ],
        "Resource": "${aws_sns_topic.foo_lambda.arn}",
        "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs_foo" {
  role       = aws_iam_role.foo_lambda.name
  policy_arn = aws_iam_policy.lambda_logging_foo.arn
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.foo_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_permission" "foo_lambda_permission" {
  # All options # Must be configured
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.foo.function_name
  # SaC Testing - Severity: Critical- Setting principal to *
  principal     = "*"
  source_arn    = aws_sns_topic.foo_lambda.arn
}
