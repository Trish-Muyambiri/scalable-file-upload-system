# modules/api_gateway/variables.tf

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "document-upload-api"
}

variable "stage_name" {
  description = "Stage name for API Gateway deployment"
  type        = string
  default     = "prod"
}

variable "authorization_type" {
  description = "Authorization type for API Gateway method"
  type        = string
  default     = "NONE"
  validation {
    condition     = contains(["NONE", "AWS_IAM", "CUSTOM", "COGNITO_USER_POOLS"], var.authorization_type)
    error_message = "Authorization type must be one of: NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLS."
  }
}

variable "lambda_function_name" {
  description = "Name of the Lambda function to integrate with"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "ARN for invoking the Lambda function"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "enable_logging" {
  description = "Enable CloudWatch logging for API Gateway"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_arn" {
  description = "CloudWatch Log Group ARN for API Gateway logging"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}

variable "enable_xray_tracing" {
  description = "Enable X-Ray tracing for API Gateway"
  type        = bool
  default     = false
}

variable "lambda_function_arn" {}