# Configuración del proveedor AWS
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Obtener la AMI más reciente de Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Módulo VPC
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  availability_zone    = var.availability_zone
  public_subnet_cidr   = var.public_subnet_cidr
  environment         = var.environment
}

# Módulo Security Group
module "security_group" {
  source = "./modules/security_group"
  
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

# Módulo EC2
module "ec2" {
  source = "./modules/ec2"
  
  ami_id            = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = var.key_name
  environment       = var.environment
}