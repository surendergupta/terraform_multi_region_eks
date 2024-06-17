terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify the required provider version
    }
  }
}

# Create the EKS Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.node_cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.node_group_subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  instance_types = var.node_instance_types
  disk_size      = var.node_disk_size
}