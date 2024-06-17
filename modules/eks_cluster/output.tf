output "name" {
  value = aws_eks_cluster.this.name
}
output "endpoint" {
  description = "EKS cluster endpoint"
  value = aws_eks_cluster.this.endpoint
}
output "cluster_security_group_id" {
  description = "Security group ID of the EKS cluster"
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}