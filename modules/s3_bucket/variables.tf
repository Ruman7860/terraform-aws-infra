variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "environment" {
  description = "Deployment environment used for safety controls and tags."
  type        = string
}

variable "force_destroy" {
  description = "Whether Terraform can destroy a non-empty bucket. Forced to false in production."
  type        = bool
  default     = false
}

variable "cors_origins" {
  description = "Allowed CORS origins for browser uploads using signed URLs."
  type        = list(string)
}

variable "cors_methods" {
  description = "Allowed CORS methods for signed URL browser access."
  type        = list(string)
}

variable "lifecycle_rules" {
  description = "Lifecycle rules to apply to bucket objects."
  type = list(object({
    id              = string
    status          = string
    prefix          = string
    expiration_days = number
  }))
}

variable "tags" {
  description = "Tags applied to bucket resources."
  type        = map(string)
  default     = {}
}
