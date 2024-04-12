terraform {
  required_providers {
    # it seems that there is a bug in latest version 5.45.0
    # during the test, they release a new version and it didn't publish
    # the api_gateway_rest_api.root_resource_id
    # so I force it to the previous version
    aws = {
      source = "hashicorp/aws"
      version = "5.44.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
provider "aws" {
  
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true


  # endpoints {
  #   ec2        = "http://localstack-main:4566"
  #   s3         = "http://localstack-main:4566"
  #   rds        = "http://localstack-main:4566"
  #   iam        = "http://localstack-main:4566"
  #   cloudwatch = "http://localstack-main:4566"
  #   lambda     = "http://localstack-main:4566"
  #   apigateway = "http://localstack-main:4566"
  #   ecr        = "http://localstack-main:4566"
  # }
  endpoints {
    ec2        = "http://localhost:4566"
    s3         = "http://localhost:4566"
    rds        = "http://localhost:4566"
    iam        = "http://localhost:4566"
    cloudwatch = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    apigateway = "http://localhost:4566"
    ecr        = "http://localhost:4510"
  }
}

