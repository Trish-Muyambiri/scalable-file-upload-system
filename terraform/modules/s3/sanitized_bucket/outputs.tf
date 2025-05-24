output "bucket_name" {
  description = "The name of the sanitized bucket"
  value       = aws_s3_bucket.sanitized_bucket.bucket
}
