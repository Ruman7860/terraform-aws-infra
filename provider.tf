terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# AWS provider for Crave Hub infrastructure in the Mumbai region.
provider "aws" {
  region = "ap-south-1"
}
