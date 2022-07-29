resource "aws_apigatewayv2_api" "pets" {
  name                         = "Pets API"
  protocol_type                = "HTTP"
  fail_on_warnings             = false
  version                      = "1"
  route_selection_expression   = "$request.method $request.path"
  disable_execute_api_endpoint = false
  route_key                    = "ANY /{proxy+}"
  target                       = "http://foo.example.org/"

  cors_configuration {
    allow_headers  = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods  = ["*"]
    allow_origins  = ["*"]
    expose_headers = ["content-type", "x-amz-date"]
    max_age        = 300
  }

  tags = {
    Environment = "webinar"
    Application = "pets"
  }
}

resource "aws_apigatewayv2_deployment" "foo" {
  api_id      = aws_apigatewayv2_api.foo.id
  description = "Example deployment"

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.foo),
      jsonencode(aws_apigatewayv2_route.foo),
      ])
    ))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_stage" "foo" {
  api_id        = aws_apigatewayv2_api.foo.id
  name          = "foo"
  auto_deploy   = false
  deployment_id = aws_apigatewayv2_deployment.foo.id

  default_route_settings {
    data_trace_enabled       = false
    detailed_metrics_enabled = false
    logging_level            = "OFF"
    throttling_burst_limit   = 10000
    throttling_rate_limit    = 5000
  }

  route_settings {
    route_key                = "ANY /{proxy+}"
    data_trace_enabled       = true
    detailed_metrics_enabled = true
    logging_level            = "ERROR"
    throttling_burst_limit   = 10000
    throttling_rate_limit    = 5000
  }

  stage_variables = {
    "version" = "02"
  }
}

resource "aws_apigatewayv2_route" "foo" {
  api_id             = aws_apigatewayv2_api.foo.id
  route_key          = "ANY /foo/{proxy+}"
  api_key_required   = false
  authorization_type = "NONE"
  operation_name     = "get_all_method"
  target             = "integrations/${aws_apigatewayv2_integration.foo.id}"
}

resource "aws_apigatewayv2_integration" "foo" {
  api_id                 = aws_apigatewayv2_api.foo.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_uri        = aws_lambda_function.foo_apigw.arn
  integration_method     = "ANY"
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "1.0"
  timeout_milliseconds   = 25000
}