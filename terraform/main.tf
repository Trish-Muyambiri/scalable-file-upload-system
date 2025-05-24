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


