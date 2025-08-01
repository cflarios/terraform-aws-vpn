variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
}

variable "availability_zone" {
  description = "Zona de disponibilidad"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block para la subnet pública"
  type        = string
}

variable "environment" {
  description = "Nombre del entorno"
  type        = string
}
