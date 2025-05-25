# main.tf for terraform module
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "quarantine_bucket" {
  source      = "./modules/s3/quarantine_bucket"
  bucket_name = "quarantine-bucket"
  tags = {
    Environment = "dev"
    Project     = "scalable-file-upload"
  }
}

module "sanitized_bucket" {
  source      = "./modules/s3/sanitized_bucket"
  bucket_name = "sanitized-bucket"
  tags = {
    Environment = "dev"
    Project     = "scalable-file-upload"
  }
}

module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = "my-presign-lambda"
  handler              = "lambda_function.lambda_handler"
  runtime              = "python3.9"
  bucket_arn           = module.quarantine_bucket.bucket_arn
  source_path          = "./modules/lambda_src/generate_presigned_url"
  environment = {
    BUCKET_NAME = module.quarantine_bucket.bucket_name
  }

  tags = {
    Project = "Generate Presigned URL Lambda"
  }
}
