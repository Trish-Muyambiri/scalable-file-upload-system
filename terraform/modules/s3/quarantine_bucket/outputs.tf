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

output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = aws_kms_key.quarantine_bucket.arn
}

