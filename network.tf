module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "aws-lab-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_dns_hostnames = true
  enable_nat_gateway   = false
}

resource "aws_security_group" "web_app" {
  name        = "web_app_sg"
  description = "Allow inbound HTTP e HTTPS traffic"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "web_app_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web_app.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.web_app.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_security_group" "rds" {
  name        = "rds_sg"
  description = "Allow inbound PostgreSQL traffic from web app security group"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "rds_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "postgresql" {
  security_group_id = aws_security_group.rds.id

  referenced_security_group_id = aws_security_group.web_app.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

