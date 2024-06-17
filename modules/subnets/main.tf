terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify the required provider version
    }
  }
}

# Create the Public Subnets
resource "aws_subnet" "this" {
  count = length(var.subnet_cidr_blocks)
  vpc_id            = var.subnet_vpc_id
  cidr_block        = var.subnet_cidr_blocks[count.index]
  availability_zone = element(var.subnet_availability_zones, count.index % length(var.subnet_availability_zones))
  map_public_ip_on_launch = true
  tags = {
    Name = format("subnet-%s-%02d", var.tag_name, count.index + 1)
  }
}