

data "archive_file" "lambda_users_get" {
  type = "zip"

  source_file  = "${path.module}/_modules/python/user-get.py"
  output_path = "${path.module}/_modules/python/user-store-get.zip"
}

data "archive_file" "lambda_users_set" {
  type = "zip"

  source_file  = "${path.module}/_modules/python/user-set.py"
  output_path = "${path.module}/_modules/python/user-store-set.zip"
}



module "Lambda" {
    source = "./_modules/lambda"
    depends_on = [module.lambda_s3_bucket]
    source_code_hash_get = data.archive_file.lambda_users_get.output_base64sha256
    source_code_hash_set= data.archive_file.lambda_users_set.output_base64sha256
    api_source_arn = module.api_gateway.apigatewayv2_api_execution_arn
}
module "lambda_s3_bucket" {
    source = "./_modules/s3"
    source_getusers = data.archive_file.lambda_users_get.output_path
    etagGetUsers=filemd5(data.archive_file.lambda_users_get.output_path)
    sourcec_setusers = data.archive_file.lambda_users_set.output_path
    etagSetUsers=filemd5(data.archive_file.lambda_users_set.output_path)
}


module "dyanmodb" {
    source = "./_modules/dynamoDB"
  
}

#using an external module here to configure api-gateway
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"
  name          = "UserApi-sandbox"
  description   = "Api-Gateway-UserApi-Testing"
  protocol_type = "HTTP"

  create = true # to disable all resources

  create_api_gateway               = true  # to control creation of API Gateway
  create_api_domain_name           = false  # to control creation of API Gateway Domain Name
  create_default_stage             = true  # to control creation of "$default" stage
  create_default_stage_api_mapping = true  # to control creation of "$default" stage and API mapping
  create_routes_and_integrations   = true  # to control creation of routes and integrations
  create_vpc_link                  = false  # to control creation of VPC link

  # Routes and integrations
  integrations = {
    "GET /get-user" = {
      lambda_arn             = module.Lambda.lambda_arn_UsersGet
      integration_type = "AWS_PROXY"
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
    
    "POST /set-user" = {
      integration_type = "AWS_PROXY"
      payload_format_version = "2.0"
      lambda_arn             = module.Lambda.lambda_arn_UsersSet

    }

  }

}