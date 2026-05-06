locals {
  # Crave Hub keeps uploads grouped by domain area:
  # restaurants/ - restaurant images, menus, and verification documents
  # users/       - customer profile media and user-generated uploads
  # orders/      - order attachments such as invoices or proof images
  # temp/        - short-lived upload staging files, deleted after 7 days
  default_bucket_names = {
    dev  = "cravehub-dev"
    prod = "cravehub"
  }

  bucket_name = coalesce(var.bucket_name, local.default_bucket_names[var.environment])

  common_tags = merge(
    {
      Project     = "Crave Hub"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# Production-ready private S3 bucket for Crave Hub application assets.
# The module keeps public access disabled and is ready for a future private
# CloudFront origin integration through signed URLs or origin access controls.
module "app_storage" {
  source = "./modules/s3_bucket"

  bucket_name     = local.bucket_name
  environment     = var.environment
  force_destroy   = var.force_destroy
  cors_origins    = var.cors_allowed_origins
  cors_methods    = var.cors_allowed_methods
  lifecycle_rules = var.lifecycle_rules
  tags            = local.common_tags
}
