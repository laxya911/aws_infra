terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "networking" {
  source      = "../../Modules/networking"
  environment = var.environment
  create_vpc  = var.create_vpc
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

module "security" {
  source          = "../../Modules/security"
  environment     = var.environment
  vpc_id          = module.networking.vpc_id
  ec2_key_name    = var.ec2_key_name
  create_key_pair = var.create_key_pair
  public_key      = var.create_key_pair ? file("${path.module}/${var.public_key_file}") : ""
}

module "compute" {
  source             = "../../Modules/compute"
  environment        = var.environment
  instances          = var.instances
  ami_id             = var.ami_id
  key_name           = module.security.key_name
  subnet_id          = module.networking.subnet_id
  security_group_ids = [module.security.security_group_id]
  user_data          = file("${path.module}/user_data.sh")
}
