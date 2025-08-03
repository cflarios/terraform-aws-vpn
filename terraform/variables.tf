# General configuration variables
variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "ssh_public_key" {
  description = "SSH public key content for EC2 access"
  type        = string
  default     = ""
}

# VPC variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet (will use first AZ in region if not specified)"
  type        = string
  default     = ""
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# EC2 variables
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
