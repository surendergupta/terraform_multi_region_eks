# Fetch the availability zones for ap-south-1 (Mumbai)
data "aws_availability_zones" "available_region1" {
  state    = "available"
  provider = aws.region1
}

# Fetch the availability zones for us-east-1 (N. Virginia)
data "aws_availability_zones" "available_region2" {
  state    = "available"
  provider = aws.region2
}

locals {
  region1_availability_zones = data.aws_availability_zones.available_region1.names
}

locals {
  region2_availability_zones = data.aws_availability_zones.available_region2.names
}

module "iam_role_cluster" {
  source        = "./modules/iam_role"
  iam_role_name = var.iam_cluster_role_name
  eks_cluster_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the required IAM policies to the EKS role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = module.iam_role_cluster.cluster_name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = module.iam_role_cluster.cluster_name
}

module "iam_role_node_group" {
  source        = "./modules/iam_role"
  iam_role_name = var.iam_node_group_role_name
  eks_cluster_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = module.iam_role_node_group.cluster_name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = module.iam_role_node_group.cluster_name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = module.iam_role_node_group.cluster_name
}

module "vpc_region1" {
  source     = "./modules/vpc"
  tag_name   = var.vpc_tag_name
  cidr_block = var.vpc_cidr_block_region1

  providers = {
    aws = aws.region1
  }
}

module "vpc_region2" {
  source     = "./modules/vpc"
  tag_name   = var.vpc_tag_name
  cidr_block = var.vpc_cidr_block_region2

  providers = {
    aws = aws.region2
  }
}

module "subnets_region1" {
  depends_on = [
    module.vpc_region1,
  ]
  source                    = "./modules/subnets"
  subnet_vpc_id             = module.vpc_region1.id
  subnet_cidr_blocks        = var.subnet_cidr_blocks_region1
  subnet_availability_zones = local.region1_availability_zones
  tag_name                  = var.subnet_tag_name

  providers = {
    aws = aws.region1
  }
}

module "subnet_region2" {
  depends_on = [
    module.vpc_region2,
  ]
  source                    = "./modules/subnets"
  subnet_vpc_id             = module.vpc_region2.id
  subnet_cidr_blocks        = var.subnet_cidr_blocks_region2
  subnet_availability_zones = local.region2_availability_zones
  tag_name                  = var.subnet_tag_name

  providers = {
    aws = aws.region2
  }
}


module "igw_region1" {
  depends_on = [
    module.vpc_region1,
  ]
  source       = "./modules/igw"
  igw_vpc_id   = module.vpc_region1.id
  igw_tag_name = var.igw_tag_name
  providers = {
    aws = aws.region1
  }
}

module "igw_region2" {
  depends_on = [
    module.vpc_region2,
  ]
  source       = "./modules/igw"
  igw_vpc_id   = module.vpc_region2.id
  igw_tag_name = var.igw_tag_name

  providers = {
    aws = aws.region2
  }
}

module "route_table_region1" {
  depends_on = [
    module.vpc_region1,
    module.igw_region1,
    module.subnets_region1,
  ]
  source         = "./modules/route_table"
  vpc_id         = module.vpc_region1.id
  igw_id         = module.igw_region1.id
  route_tag_name = var.route_tag_name_region1
  subnet_ids     = module.subnets_region1.subnet_ids

  providers = {
    aws = aws.region1
  }
}

module "route_table_region2" {
  depends_on = [
    module.vpc_region2,
    module.igw_region2,
    module.subnet_region2,
  ]
  source         = "./modules/route_table"
  vpc_id         = module.vpc_region2.id
  igw_id         = module.igw_region2.id
  route_tag_name = var.route_tag_name_region2
  subnet_ids     = module.subnet_region2.subnet_ids
  providers = {
    aws = aws.region2
  }
}

module "eks_cluster_region1" {
  depends_on = [
    module.vpc_region1,
    module.igw_region1,
    module.route_table_region1,
    module.iam_role_cluster,
    module.subnets_region1,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy,
  ]

  source          = "./modules/eks_cluster"
  my_cluster_name = "${var.eks_cluster_name}-region1"
  cluster_arn     = module.iam_role_cluster.cluster_arn
  subnet_ids      = module.subnets_region1.subnet_ids

  providers = {
    aws = aws.region1
  }
}

module "eks_cluster_region2" {
  depends_on = [
    module.vpc_region2,
    module.igw_region2,
    module.route_table_region2,
    module.iam_role_cluster,
    module.subnet_region2,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy,
  ]

  source          = "./modules/eks_cluster"
  my_cluster_name = "${var.eks_cluster_name}-region2"
  cluster_arn     = module.iam_role_cluster.cluster_arn
  subnet_ids      = module.subnet_region2.subnet_ids

  providers = {
    aws = aws.region2
  }
}

module "cluster_node_group_region1" {
  depends_on = [
    module.eks_cluster_region1,
    module.subnets_region1,
    module.iam_role_node_group,
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
  ]

  source                = "./modules/eks_node_group"
  node_cluster_name     = module.eks_cluster_region1.name
  node_group_name       = "${var.eks_cluster_node_group_name}-region1"
  node_group_role_arn   = module.iam_role_node_group.cluster_arn
  node_group_subnet_ids = module.subnets_region1.subnet_ids
  node_desired_size     = 2
  node_max_size         = 5
  node_min_size         = 2
  node_instance_types   = var.node_instance_type
  node_disk_size        = 25

  providers = {
    aws = aws.region1
  }
}

module "cluster_node_group_region2" {
  depends_on = [
    module.eks_cluster_region2,
    module.subnet_region2,
    module.iam_role_node_group,
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
  ]

  source                = "./modules/eks_node_group"
  node_cluster_name     = module.eks_cluster_region2.name
  node_group_name       = "${var.eks_cluster_node_group_name}-region2"
  node_group_role_arn   = module.iam_role_node_group.cluster_arn
  node_group_subnet_ids = module.subnet_region2.subnet_ids
  node_desired_size     = 2
  node_max_size         = 5
  node_min_size         = 2
  node_instance_types   = var.node_instance_type
  node_disk_size        = 25

  providers = {
    aws = aws.region2
  }
}