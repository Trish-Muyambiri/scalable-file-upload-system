# main.tf for dev module
provider "aws" {
  region = "us-east-1" # or your preferred region
}

module "quarantine_bucket" {
  source = "../../modules/s3/quarantine"

  bucket_name = "quarantine-bucket"
  tags = {
    Environment = "dev"
    Project     = "ScalableFileUpload"
  }
}



