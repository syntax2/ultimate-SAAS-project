terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_s3_bucket" "example" {
  bucket = "demo-ashish-terraform-eks-state-file"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "terraform-eks-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}