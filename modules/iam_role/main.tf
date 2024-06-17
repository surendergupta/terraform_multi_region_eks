terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify the required provider version
    }
  }
}

# Create the IAM role for EKS
resource "aws_iam_role" "this" {
  name = var.iam_role_name
  assume_role_policy = var.eks_cluster_role_policy
}
