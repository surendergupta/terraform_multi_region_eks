variable "subnet_vpc_id" {
  description = "The ID of the VPC where the subnets will be created"
  type        = string
}

variable "subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the subnets"
  type        = list(string)
}

variable "subnet_availability_zones" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
}

variable "tag_name" {
  description = "The name of the tag to be applied to the subnets"
  type        = string
}