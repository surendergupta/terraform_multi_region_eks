# Multi-Region EKS Cluster Deployment with Terraform

Deploy highly available and resilient Kubernetes clusters across multiple AWS regions using Terraform.

## Table of Contents

- Introduction
- Features
- Prerequisites
- Getting Started
- Project Structure
- Usage
- Contributing
- License
- Acknowledgements
- Commands in Terminal
- Screenshots

## Introduction

This repository provides a Terraform configuration to deploy EKS (Elastic Kubernetes Service) clusters in multiple AWS regions, ensuring high availability and disaster recovery capabilities. By leveraging Terraform, you can automate the infrastructure setup and manage it as code.

## Features
- Multi-Region Deployment: Deploy EKS clusters in Mumbai (ap-south-1) and N. Virginia (us-east-1) regions.
- IAM Role Management: Conditional creation of IAM roles and policies to avoid duplication errors.
- Automated Networking: Setup VPCs, subnets, route tables, and internet gateways in each region.
- Scalable and Maintainable: Manage your infrastructure with Terraform, making it reproducible and easy to scale.

## Prerequisites
- Terraform v1.0+
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create EKS clusters and associated resources

## Getting Started
Follow these steps to deploy the multi-region EKS clusters:

1. Clone the Repository:

```bash
git clone https://github.com/surendergupta/terraform_multi_region_eks.git
cd terraform_multi_region_eks

```

2. Initialize Terraform:

```bash
terraform init
```

3. Review and Modify Variables:

- Edit the variables.tf file to configure your desired settings such as VPC CIDR blocks, subnet CIDR blocks, and EKS cluster names.

4. Deploy the Infrastructure:

```bash
terraform apply
```

5. Confirm the Apply:

- Type yes when prompted to confirm the apply.

## Project Structure

```css
.
├── modules/
│   ├── iam_role/
│   ├── vpc/
│   ├── subnets/
│   ├── igw/
│   ├── route_table/
│   └── eks_cluster/
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
└── LICENSE

```

## Usage

1. IAM Role Management:
    - The IAM roles and policies are conditionally created based on their existence. This prevents duplication errors and ensures idempotency.

2. Networking:

    - The VPC, subnets, and related resources are created in both regions to ensure isolated and well-architected network setups.

3. EKS Cluster:

    - EKS clusters are deployed in both regions, utilizing the IAM roles and networking components configured earlier.

## Contributing

Contributions are welcome! To contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch: git checkout -b feature-branch-name
3. Make your changes and commit them: git commit -m 'Add some feature'
4. Push to the branch: git push origin feature-branch-name
5. Open a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Thanks to the Terraform and AWS communities for their invaluable resources and support.


## Command in Terminal

```bash
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve

```

# Screenshots

![Apply Success](./screenshots/image.png)

![tree structure](./screenshots/image-1.png)