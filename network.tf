terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
    }
  }
  required_version = "~> 0.14"
  backend "s3" {
    bucket               = "yuan-terraform-backend"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "terraform-workspaces"
    dynamodb_table       = "s3-state-lock"
    region               = "ap-southeast-2"
 }



provider "aws" {
  region = "ap-southeast-2"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "simple-example"

  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-2a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_ipv6 = true

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_s3_endpoint       = false
  enable_dynamodb_endpoint = false

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-demo"

  }
}
