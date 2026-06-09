# terraform-aws-free-tier

Infrastructure as Code project that provisions a complete AWS environment
(VPC, EC2, Lambda, API Gateway, RDS, S3 and DynamoDB) using Terraform
while remaining within AWS Free Tier limits.

## Architecture

- VPC with public and private subnets
- Internet Gateway and route tables
- Security Groups
- EC2 (Amazon Linux 2023)
- Lambda + API Gateway
- RDS PostgreSQL
- S3 Bucket with versioning
- DynamoDB table with GSI

## Requirements

- Terraform >= 1.5
- AWS CLI configured
- AWS Account (Free Tier)

## Usage

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply

