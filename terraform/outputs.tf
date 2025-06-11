output "quarantine_bucket_name" {
  value = module.quarantine_bucket.bucket_name
}

output "bucket_name" {
  description = "Name of the quarantine bucket"
  value       = module.quarantine_bucket.bucket_name
}

output "bucket_arn" {
  description = "ARN of the quarantine bucket"
  value       = module.quarantine_bucket.bucket_arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda.lambda_function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.lambda_function_arn
}

output "lambda_invoke_arn" {
  description = "Lambda invoke ARN for API Gateway"
  value       = module.lambda.lambda_invoke_arn
}
output "api_gateway_url" {
  description = "Base URL of the API Gateway"
  value       = module.api_gateway.api_gateway_url
}

output "presigned_url_endpoint" {
  description = "Full endpoint URL for generating presigned URLs"
  value       = module.api_gateway.presigned_url_endpoint
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = module.api_gateway.api_gateway_id
}