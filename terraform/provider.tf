provider "aws" {
  region = "ap-south-2"
  access_key = "your aws account access key"
  secret_key = "your aws account secret key"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
}

