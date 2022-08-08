

module "Lambda" {
    source ="../modules/lambda"
    depends_on = [module.lambda_s3_bucket]
}

module "lambda_s3_bucket" {
    source ="../modules/s3"

}

module "dyanmodb" {
    source = "../modules/dyanmodb"
  
}

#using an external module here to configure api-gateway
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"
  name          = "petstore-sandbox"
  description   = "Api-Gateway-Petstore-Testing"
  protocol_type = "HTTP"

  create = true # to disable all resources

  create_api_gateway               = true  # to control creation of API Gateway
  create_api_domain_name           = false  # to control creation of API Gateway Domain Name
  create_default_stage             = false  # to control creation of "$default" stage
  create_default_stage_api_mapping = false  # to control creation of "$default" stage and API mapping
  create_routes_and_integrations   = true  # to control creation of routes and integrations
  create_vpc_link                  = false  # to control creation of VPC link

  # Routes and integrations
  integrations = {
    "POST /put-pet" = {
      lambda_arn             = module.Lambda.function_name.PetStoreGet.invoke_arn
      integration_type = "AWS_PROXY"
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
    
    "GET /get-pet" = {
      integration_type = "AWS_PROXY"
      lambda_arn             = module.Lambda.function_name.PetStoreGet.invoke_arn

    }

  }

}