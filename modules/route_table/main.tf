terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify the required provider version
    }
  }
}

# Create the Route Table for Public Subnets
resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = var.route_tag_name
  }
}

resource "aws_route_table_association" "this" {
  for_each = { for idx, subnet_id in var.subnet_ids : idx => subnet_id }

  subnet_id      = each.value
  route_table_id = aws_route_table.this.id
}