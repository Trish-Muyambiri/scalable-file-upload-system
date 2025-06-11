output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.generate_presigned_url.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.generate_presigned_url.arn
}

output "lambda_exec_role_arn" {
  value       = aws_iam_role.lambda_exec.arn
  description = "IAM role ARN used by the Lambda function"
}

output "lambda_invoke_arn" {
  description = "Invoke ARN for the Lambda function (used by API Gateway)"
  value       = aws_lambda_function.generate_presigned_url.invoke_arn
}

output "lambda_qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = aws_lambda_function.generate_presigned_url.qualified_arn
}

output "lambda_version" {
  description = "Latest published version of the Lambda function"
  value       = aws_lambda_function.generate_presigned_url.version
}

output "lambda_role_name" {
  description = "Name of the IAM role used by the Lambda function"
  value       = aws_iam_role.lambda_exec.name
}

output "lambda_last_modified" {
  description = "Date the Lambda function was last modified"
  value       = aws_lambda_function.generate_presigned_url.last_modified
}

output "lambda_source_code_hash" {
  description = "Base64-encoded SHA256 hash of the Lambda deployment package"
  value       = aws_lambda_function.generate_presigned_url.source_code_hash
}

output "invoke_arn" {
  value = aws_lambda_function.generate_presigned_url.invoke_arn
}

/**
output "cloudwatch_log_group_arn" {
  value = length(aws_cloudwatch_log_group.api_gateway_logs) > 0 ? aws_cloudwatch_log_group.api_gateway_logs[0].arn : null
  description = "ARN of the CloudWatch Log Group for API Gateway (if created)"
}
**/