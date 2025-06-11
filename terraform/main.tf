terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

# Provider configuration
provider "aws" {
  region = var.aws_region
}

# Local values
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# Lambda module
module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = "${var.project_name}-presign-lambda-${var.environment}"
  handler              = "lambda_function.lambda_handler"
  runtime              = "python3.12"
  source_path          = "${path.root}/modules/lambda_src/generate_presigned_url"
  
  bucket_arn = module.quarantine_bucket.bucket_arn
  
  environment = {
    BUCKET_NAME = module.quarantine_bucket.bucket_name
    ENVIRONMENT = var.environment
  }

  tags = local.common_tags
}

# S3 bucket module
module "quarantine_bucket" {
  source          = "./modules/s3/quarantine_bucket"
  bucket_name     = "${var.project_name}-quarantine"
  environment     = var.environment
  tags            = local.common_tags
  lambda_role_arn = module.lambda.lambda_exec_role_arn
}

module "sanitized_bucket" {
  source      = "./modules/s3/sanitized_bucket"
  bucket_name = "sanitized-bucket"
  tags = {
    Environment = "dev"
    Project     = "scalable-file-upload"
  }
}

# API Gateway Module
module "api_gateway" {
  source                = "./modules/api_gateway"
  lambda_function_arn = module.lambda.lambda_function_arn
  lambda_function_name = module.lambda.lambda_function_name 
  api_name              = var.api_name
  stage_name            = var.stage_name
  authorization_type    = var.authorization_type
  lambda_invoke_arn     = module.lambda.invoke_arn
  enable_logging        = false #var.enable_api_logging
  enable_xray_tracing   = var.enable_xray_tracing
  tags                  = var.tags
}

