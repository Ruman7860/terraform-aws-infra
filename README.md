# Crave Hub AWS Infrastructure

Production-grade Terraform for Crave Hub AWS resources.

## Folder Structure

```text
.
├── backend.tf                 # Remote Terraform state backend configuration
├── provider.tf                # AWS provider and Terraform requirements
├── main.tf                    # Root composition layer
├── variables.tf               # Root variables and validations
├── outputs.tf                 # Root outputs
├── environments/
│   ├── dev/terraform.tfvars   # Dev values: bucket cravehub-dev
│   └── prod/terraform.tfvars  # Prod values: bucket cravehub
└── modules/
    └── s3_bucket/             # Reusable private S3 bucket module
```

## S3 Object Prefixes

```text
restaurants/  # Restaurant images, menus, and verification documents
users/        # Customer profile media and user-generated uploads
orders/       # Order attachments such as invoices or proof images
temp/         # Short-lived upload staging files, deleted after 7 days
```

## Usage

```bash
terraform init
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars
```

For production:

```bash
terraform plan -var-file=environments/prod/terraform.tfvars
terraform apply -var-file=environments/prod/terraform.tfvars
```

The bucket is private by default. Frontend uploads should use backend-generated signed URLs, and future CloudFront integration should use a private origin access pattern.
