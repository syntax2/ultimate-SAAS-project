terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "demo-ashish-terraform-eks-state-file"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-eks-state-lock"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC

module "vpc" {
  source = "./modules/vpc"

  cluster_name          = var.cluster_name
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
}

