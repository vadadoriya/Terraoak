
resource "aws_api_gateway_authorizer" "foo" {
  # All options # Must be configured
  name                             = "CognitoUserPoolAuthorizer"
  type                             = "COGNITO_USER_POOLS"
  rest_api_id                      = aws_api_gateway_rest_api.foo.id
  provider_arns                    = [aws_cognito_user_pool.foo.arn]
  authorizer_result_ttl_in_seconds = 30 # Must be less than equal to 30
  identity_source                  = "method.request.header.Authorization"
}

resource "aws_api_gateway_authorizer" "bar" {
  # All options # Must be configured
  name                             = "CustomAuthorizer"
  type                             = "TOKEN"
  rest_api_id                      = aws_api_gateway_rest_api.foo.id
  authorizer_result_ttl_in_seconds = 30 # Must be less than equal to 30
  authorizer_uri                   = aws_lambda_function.foo_apigw.invoke_arn
  identity_source                  = "method.request.header.Authorization" 
  # Applies when authorizer type is Custom
  # authorizer_credentials           = var.authorizer_credentials # Must be configured
}

resource "aws_api_gateway_request_validator" "foo" {
  # All options # Must be configured
  name                        = "foo"
  rest_api_id                 = aws_api_gateway_rest_api.foo.id
  validate_request_body       = true
  validate_request_parameters = true
}
