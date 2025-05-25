variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "source_path" {
  description = "Path to the Lambda source code directory"
  type        = string
}

variable "handler" {
  description = "Lambda function entry point (e.g. main.lambda_handler)"
  type        = string
  default     = "main.lambda_handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.12"
}

variable "environment" {
  description = "Environment variables to pass to the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the Lambda function"
  type        = map(string)
  default     = {}
}

variable "bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket to which Lambda can upload"
}
