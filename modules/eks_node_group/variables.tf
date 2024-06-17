variable "node_cluster_name" {
  description = "Cluster name for node group"
}

variable "node_group_name" {
  description = "Cluster name for node group"
}

variable "node_group_role_arn" {
  description = "Node group role arn"
}

variable "node_group_subnet_ids" {
  description = "Node group subnet ids"
}

variable "node_desired_size" {
  description = "Node desired size"
}

variable "node_max_size" {
  description = "Node max"
}

variable "node_min_size" {
  description = "Node min"
}

variable "node_instance_types" {
  description = "Node instance type"
}

variable "node_disk_size" {
  description = "Node disk space"
}