variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project = "FileUpload"
    Owner   = "Patricia"
  }
}


variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "scalable-file-upload"
}


variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "document-upload-api"
}

variable "stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "prod"
}

variable "authorization_type" {
  description = "API Gateway authorization type"
  type        = string
  default     = "NONE"
}

variable "enable_api_logging" {
  description = "Enable API Gateway logging"
  type        = bool
  default     = true
}

variable "enable_xray_tracing" {
  description = "Enable X-Ray tracing"
  type        = bool
  default     = false
}
