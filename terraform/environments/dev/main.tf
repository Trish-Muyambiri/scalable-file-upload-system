provider "aws" {
  region = "us-east-1" # adjust as needed
}

resource "random_pet" "suffix" {}

module "presigned_url_lambda" {
  source = "../../modules/lambda"

  lambda_function_name = "generate-presigned-url-${random_pet.suffix.id}"
  handler              = "main.lambda_handler"
  runtime              = "python3.12"
  source_path          = "${path.module}/../../src/lambdas/presigned_url"

  environment = {
    BUCKET_NAME = "quarantine-bucket-${random_pet.suffix.id}"
    URL_EXPIRY  = "300" # seconds
  }

  tags = {
    Environment = "dev"
    Project     = "ScalableFileUpload"
  }
}
