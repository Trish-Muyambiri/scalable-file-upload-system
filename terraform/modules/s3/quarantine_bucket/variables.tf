variable "bucket_name" {
  description = "The base name of the S3 bucket"
  type        = string
  default     = "quarantine_bucket"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "tags" {
  description = "Tags to apply to the S3 bucket and associated resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "scalable-file-upload"
    Purpose     = "KYC Document Storage"
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

variable "lambda_role_arn" {
  description = "The ARN of the Lambda execution role allowed to access the bucket"
  type        = string
}

# Upload Configuration
variable "upload_prefix" {
  description = "Prefix for user uploads"
  type        = string
  default     = "uploads/"
}

variable "temp_prefix" {
  description = "Prefix for temporary files"
  type        = string
  default     = "temp/"
}

variable "allowed_file_types" {
  description = "List of allowed file extensions for uploads"
  type        = list(string)
  default     = ["pdf", "jpg", "jpeg", "png", "doc", "docx"]
}

variable "max_file_size_mb" {
  description = "Maximum file size allowed in MB"
  type        = number
  default     = 10
  
  validation {
    condition     = var.max_file_size_mb > 0 && var.max_file_size_mb <= 100
    error_message = "Max file size must be between 1 and 100 MB."
  }
}

# Lifecycle Configuration
variable "upload_retention_days" {
  description = "Number of days to retain uploaded files before moving to cold storage"
  type        = number
  default     = 90
}

variable "temp_expiration_days" {
  description = "Number of days after which temporary files should expire"
  type        = number
  default     = 7
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days to retain non-current versions"
  type        = number
  default     = 30
}

# Security Configuration
variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_mfa_delete" {
  description = "Enable MFA delete on the S3 bucket"
  type        = bool
  default     = false
}

# Encryption Configuration
variable "encryption_type" {
  description = "Server-side encryption type (AES256)"
  type        = string
  default     = "AES256"
  
  validation {
    condition     = contains(["AES256", "aws:kms"], var.encryption_type)
    error_message = "Encryption type must be either AES256"
  }
}

