# main.tf for s3 module

# create bucket
resource "aws_s3_bucket" "quarantine_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}


# block public access
resource "aws_s3_bucket_public_access_block" "quarantine_bucket" {
  bucket = aws_s3_bucket.quarantine_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# enable versioning
resource "aws_s3_bucket_versioning" "versioning_quarantine_bucket" {
  bucket = aws_s3_bucket.quarantine_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable encryption
resource "aws_kms_key" "quarantine_bucket" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "quarantine_bucket_key" {
  bucket = aws_s3_bucket.quarantine_bucket.id

  depends_on = [aws_kms_key.quarantine_bucket]

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.quarantine_bucket.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


# lifecyle rules
resource "aws_s3_bucket_lifecycle_configuration" "quarantine_bucket" {
  bucket = aws_s3_bucket.quarantine_bucket.id

  rule {
    id     = "auto-delete-temp"
    status = "Enabled"

    expiration {
      days = 30
    }

    filter {
      prefix = "temp/"
    }
  }
}

