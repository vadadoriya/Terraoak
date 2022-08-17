resource "aws_apigatewayv2_api" "user_webinar" {

  name          = var.name
  description   = var.description
  protocol_type = var.protocol_type
}

resource "aws_apigatewayv2_stage" "default" {

  api_id      = aws_apigatewayv2_api.user_webinar.id
  name        = "$default"
  auto_deploy = true

    lifecycle {
    ignore_changes = [deployment_id]
  }
}

# Routes and integrations
resource "aws_apigatewayv2_route" "get-user" {

  api_id    = aws_apigatewayv2_api.user_webinar.id
  route_key = "GET /get-user"
  target = "integrations/${aws_apigatewayv2_integration.get-user.id}"

}

# Routes and integrations
resource "aws_apigatewayv2_route" "set-user" {

  api_id    = aws_apigatewayv2_api.user_webinar.id
  route_key = "POST /set-user"
  target = "integrations/${aws_apigatewayv2_integration.set-user.id}"

}

resource "aws_apigatewayv2_integration" "get-user" {
  api_id           = aws_apigatewayv2_api.user_webinar.id
  integration_type = "AWS_PROXY"
  payload_format_version = "2.0"
  timeout_milliseconds   = 12000
  integration_uri           = var.lambda_arn_get_user
  
  
}

resource "aws_apigatewayv2_integration" "set-user" {
  api_id           = aws_apigatewayv2_api.user_webinar.id
  integration_type = "AWS_PROXY"
  payload_format_version = "2.0"
  timeout_milliseconds   = 12000
  integration_uri            = var.lambda_arn_set_user
}