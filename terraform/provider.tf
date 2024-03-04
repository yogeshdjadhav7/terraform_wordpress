provider "aws" {
  region = "ap-south-2"
  access_key = "AKIAWMEN7TFIDVYEXLGI"
  secret_key = "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"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
}

