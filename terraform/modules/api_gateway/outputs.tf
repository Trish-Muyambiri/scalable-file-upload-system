# modules/api_gateway/outputs.tf

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = aws_api_gateway_rest_api.document_upload_api.id
}

output "api_gateway_arn" {
  description = "ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.document_upload_api.arn
}

output "api_gateway_execution_arn" {
  description = "Execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.document_upload_api.execution_arn
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = "https://${aws_api_gateway_rest_api.document_upload_api.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${var.stage_name}"
}

output "presigned_url_endpoint" {
  description = "Full endpoint URL for generating presigned URLs"
  value       = "https://${aws_api_gateway_rest_api.document_upload_api.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${var.stage_name}/generate-presigned-url"
}

output "api_gateway_stage_name" {
  description = "Stage name of the API Gateway deployment"
  value       = var.stage_name
}




/**
output "cloudwatch_log_group_arn" {
  value = length(aws_cloudwatch_log_group.api_gateway_logs) > 0 ? aws_cloudwatch_log_group.api_gateway_logs[0].arn : null
  description = "ARN of the CloudWatch Log Group for API Gateway (if created)"
}
**/