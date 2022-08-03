
resource "aws_apigatewayv2_api" "pets" {
  name                         = "serverless_lambda_petstore"
  protocol_type                = "HTTP"
}
