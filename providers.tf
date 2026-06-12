terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.50.0"
    }
  }
  required_version = ">= 1.5"
}

provider "aws" {
  region = "us-east-1"
}

