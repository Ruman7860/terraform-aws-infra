variable "environment" {
  description = "Deployment environment. Supported values map to standard Crave Hub bucket names."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either dev or prod."
  }
}

variable "bucket_name" {
  description = "Optional S3 bucket name override. Defaults to cravehub-dev for dev and cravehub for prod."
  type        = string
  default     = null

  validation {
    condition     = var.bucket_name == null || can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be a valid DNS-compatible S3 bucket name."
  }
}

variable "force_destroy" {
  description = "Whether Terraform can delete a non-empty bucket. This module always disables it for prod."
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "Frontend origins allowed to upload through signed URLs."
  type        = list(string)
  default = [
    "http://localhost:3000",
    "https://cravehub.com"
  ]
}

variable "cors_allowed_methods" {
  description = "HTTP methods allowed by S3 CORS for browser-based signed URL operations."
  type        = list(string)
  default     = ["GET", "PUT", "POST"]
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for automated S3 object retention management."
  type = list(object({
    id              = string
    status          = string
    prefix          = string
    expiration_days = number
  }))
  default = [
    {
      id              = "delete-temp-objects-after-7-days"
      status          = "Enabled"
      prefix          = "temp/"
      expiration_days = 7
    }
  ]
}

variable "tags" {
  description = "Additional tags to apply to all supported resources."
  type        = map(string)
  default     = {}
}
