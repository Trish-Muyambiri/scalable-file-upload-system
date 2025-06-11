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

  validation {
    condition     = contains(["python3.9", "python3.10", "python3.11", "python3.12"], var.runtime)
    error_message = "Runtime must be a supported Python version."
  }
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

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900
    error_message = "Timeout must be between 1 and 900 seconds."
  }
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "Memory size must be between 128 and 10240 MB."
  }
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable "enable_dlq" {
  description = "Enable Dead Letter Queue"
  type        = bool
  default     = true
}

variable "api_gateway_arn" {
  description = "API Gateway ARN for Lambda permissions"
  type        = string
  default     = null
}

variable "presigned_url_expiration" {
  description = "Presigned URL expiration time in seconds"
  type        = number
  default     = 1800  # 30 minutes
  
  validation {
    condition     = var.presigned_url_expiration >= 60 && var.presigned_url_expiration <= 604800
    error_message = "Expiration must be between 1 minute and 7 days."
  }
}

variable "allowed_file_types" {
  description = "List of allowed file extensions"
  type        = list(string)
  default     = ["pdf", "jpg", "jpeg", "png", "doc", "docx"]
}

variable "max_file_size_bytes" {
  description = "Maximum file size in bytes"
  type        = number
  default     = 10485760  # 10MB
}

variable "reserved_concurrency" {
  description = "Reserved concurrency for the Lambda function (-1 for unreserved)"
  type        = number
  default     = -1
  
  validation {
    condition     = var.reserved_concurrency >= -1
    error_message = "Reserved concurrency must be -1 or greater."
  }
}