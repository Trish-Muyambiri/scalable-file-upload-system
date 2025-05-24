variable "bucket_name" {
  description = "The name of the S3 bucket to be created"
  type        = string
  default     = "quarantine-bucket"
}

variable "tags" {
  description = "Tags to apply to the S3 bucket and associated resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "scalable-file-upload"
  }
}

variable "lifecycle_prefix" {
  description = "Prefix for objects to apply lifecycle rules to (e.g., temp/)"
  type        = string
  default     = "temp/"
}

variable "lifecycle_expiration_days" {
  description = "Number of days after which objects with the specified prefix should expire"
  type        = number
  default     = 30
}

variable "kms_deletion_window_days" {
  description = "Waiting period before a KMS key is deleted after being scheduled for deletion"
  type        = number
  default     = 10
}

variable "kms_description" {
  description = "Description of the KMS key"
  type        = string
  default     = "This key is used to encrypt bucket objects"
}

