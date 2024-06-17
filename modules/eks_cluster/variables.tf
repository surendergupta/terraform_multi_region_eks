variable "my_cluster_name" {
  description = "EKS Cluster Name"
}

variable "cluster_arn" {
  description = "EKS Cluster ARN Role"
}

variable "subnet_ids" {
  description = "List of subnet IDs where EKS nodes will be placed"
  type    = list(string)
  default = []
}