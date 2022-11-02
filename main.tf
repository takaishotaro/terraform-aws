terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "tf-state-20221102"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
