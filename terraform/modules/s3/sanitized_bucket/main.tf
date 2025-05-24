resource "aws_s3_bucket" "sanitized_bucket" {
  bucket = "${var.bucket_name}-${random_pet.suffix.id}"
  tags   = var.tags
}

resource "aws_s3_bucket_public_access_block" "sanitized_bucket" {
  bucket = aws_s3_bucket.sanitized_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_sanitized_bucket" {
  bucket = aws_s3_bucket.sanitized_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "sanitized_bucket" {
  description             = "KMS key for sanitized S3 bucket"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sanitized_bucket_encryption" {
  bucket = aws_s3_bucket.sanitized_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.sanitized_bucket.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "sanitized_bucket_lifecycle" {
  bucket = aws_s3_bucket.sanitized_bucket.id

  rule {
    id     = "expire-archived"
    status = "Enabled"

    expiration {
      days = 60
    }

    filter {
      prefix = "archived/"
    }
  }
}

resource "random_pet" "suffix" {
  length = 2
}
