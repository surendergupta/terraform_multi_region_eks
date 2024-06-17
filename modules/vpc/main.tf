terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify the required provider version
    }
  }
}

# Create the VPC
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.tag_name
  }
}