variable "vpc_id" {
  description = "ID de la VPC donde crear el security group"
  type        = string
}

variable "environment" {
  description = "Nombre del entorno"
  type        = string
}
