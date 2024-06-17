terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify the required provider version
    }
  }
}

# Create the EKS cluster
resource "aws_eks_cluster" "this" {
  name     = var.my_cluster_name
  role_arn = var.cluster_arn

  vpc_config {
    subnet_ids = toset(var.subnet_ids)
  }
}