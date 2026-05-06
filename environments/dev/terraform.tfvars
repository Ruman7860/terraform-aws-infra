environment = "dev"
bucket_name = "cravehub-dev"

force_destroy = false

cors_allowed_origins = [
  "http://localhost:3000",
  "https://cravehub.com"
]

cors_allowed_methods = ["GET", "PUT", "POST"]

tags = {
  Owner      = "Crave Hub Platform"
  CostCenter = "cravehub-dev"
}
