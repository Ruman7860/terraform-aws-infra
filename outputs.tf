output "bucket_name" {
  description = "Name of the private Crave Hub S3 bucket."
  value       = module.app_storage.bucket_name
}

output "bucket_arn" {
  description = "ARN of the private Crave Hub S3 bucket."
  value       = module.app_storage.bucket_arn
}

output "bucket_region" {
  description = "AWS region where the bucket is deployed."
  value       = module.app_storage.bucket_region
}
