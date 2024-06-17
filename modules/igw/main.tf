terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify the required provider version
    }
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = var.igw_vpc_id

  tags = {
    Name = var.igw_tag_name
  }
}