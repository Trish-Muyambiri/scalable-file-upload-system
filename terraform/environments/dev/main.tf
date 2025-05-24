# main.tf for dev module
provider "aws" {
  region = "us-east-1" # or your preferred region
}

module "quarantine_bucket" {
  source = "../../modules/s3"

  bucket_name = "quarantine-bucket-${random_pet.suffix.id}"
  tags = {
    Environment = "dev"
    Project     = "ScalableFileUpload"
  }
}



