output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.generate_presigned_url.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.generate_presigned_url.arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM role used by the Lambda function"
  value       = aws_iam_role.lambda_exec.arn
}
