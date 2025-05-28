/** 
output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.quarantine_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.quarantine_bucket.arn
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = "${var.bucket_name}-${random_pet.suffix.id}"
}



**/
output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.quarantine_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.quarantine_bucket.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.quarantine_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket regional domain name"
  value       = aws_s3_bucket.quarantine_bucket.bucket_regional_domain_name
}

output "bucket_region" {
  description = "The AWS region of the bucket"
  value       = aws_s3_bucket.quarantine_bucket.region
}

output "upload_prefix" {
  description = "Prefix for uploads in the bucket"
  value       = "uploads/"
}