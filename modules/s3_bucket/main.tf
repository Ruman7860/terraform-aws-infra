locals {
  # Production safety: prod buckets must never be force-destroyed by Terraform.
  effective_force_destroy = var.environment == "prod" ? false : var.force_destroy
}

# Private S3 bucket for Crave Hub application objects.
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = local.effective_force_destroy

  tags = merge(
    var.tags,
    {
      Name = var.bucket_name
    }
  )
}

# Blocks all public ACLs and public bucket policies at the S3 control plane.
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enforces bucket-owner ownership and disables ACL-based access management.
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Enables object versioning so accidental overwrites and deletes can be recovered.
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypts all objects at rest using Amazon S3 managed AES256 encryption.
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Allows browser clients to use backend-generated signed URLs without exposing
# public bucket access. Future CloudFront origins should remain private too.
resource "aws_s3_bucket_cors_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = var.cors_methods
    allowed_origins = var.cors_origins
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Deletes short-lived staging uploads from temp/ after the configured retention.
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      id     = rule.value.id
      status = rule.value.status

      filter {
        prefix = rule.value.prefix
      }

      expiration {
        days = rule.value.expiration_days
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}
