output "availability" {
  value = data.aws_availability_zones.available_region1
}

output "availability_us" {
  value = data.aws_availability_zones.available_region2
}

output "EKSClusterPolicy" {
  value = aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
}

output "EKSServicePolicy" {
  value = aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy
}

output "EKSWorkerNodePolicy" {
  value = aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy
}

output "EKS_CNI_Policy" {
  value = aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy
}

output "EC2ContainerRegistryReadOnly" {
  value = aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly
}

output "subnet_ap" {
  # value = flatten([for module_instance in module.subnets_apsouth : module_instance.subnet_ids])
  value = module.subnets_region1.subnet_ids
}

output "subnet_us" {
  # value = flatten([for module_instance in module.subnet_useast : module_instance.subnet_ids])
  value = module.subnet_region2.subnet_ids
}

output "vpc_cidr_block_ap" {
  value = module.vpc_region1.cidr_block
}

output "vpc_cidr_block_us" {
  value = module.vpc_region2.cidr_block
}