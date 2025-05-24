variable "bucket_name" {
  description = "The name of the S3 bucket to be created"
  type        = string
  default     = "sanitized-bucket"
}

variable "tags" {
  description = "Tags to apply to the S3 bucket and associated resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "scalable-file-upload"
  }
}