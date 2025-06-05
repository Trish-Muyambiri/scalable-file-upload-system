resource "random_pet" "suffix" {
  length = 2
}

# Create the S3 bucket
resource "aws_s3_bucket" "quarantine_bucket" {
  bucket = "${var.bucket_name}-${random_pet.suffix.id}"
  tags   = var.tags
}

# Block public access
resource "aws_s3_bucket_public_access_block" "quarantine_bucket_public_access_block" {
  bucket = aws_s3_bucket.quarantine_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "quarantine_bucket_versioning" {
  bucket = aws_s3_bucket.quarantine_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable SSE-S3 encryption (AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "quarantine_bucket_key" {
  bucket = aws_s3_bucket.quarantine_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle rule to auto-delete objects in temp/ after 30 days
resource "aws_s3_bucket_lifecycle_configuration" "quarantine_bucket_lifecycle_configuration" {
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


# Allow Lambda role to upload to this bucket
resource "aws_s3_bucket_policy" "quarantine_bucket_policy" {
  bucket = aws_s3_bucket.quarantine_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.quarantine_bucket_public_access_block]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowLambdaAccess",
        Effect = "Allow",
        Principal = {
          AWS = var.lambda_role_arn
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.quarantine_bucket.arn}/*"
      },
      {
        Sid    = "AllowPresignedUploads",
        Effect = "Allow",
        Principal = "*",
        Action = "s3:PutObject",
        Resource = "${aws_s3_bucket.quarantine_bucket.arn}/uploads/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-server-side-encryption" = "AES256"
          }
        }
      }
    ]
  })
}

