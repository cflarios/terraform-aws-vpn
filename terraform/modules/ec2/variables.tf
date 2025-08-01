variable "ami_id" {
  description = "ID de la AMI a utilizar"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subnet donde crear la instancia"
  type        = string
}

variable "security_group_id" {
  description = "ID del security group"
  type        = string
}

variable "key_name" {
  description = "Nombre del key pair para SSH"
  type        = string
  default     = null
}

variable "environment" {
  description = "Nombre del entorno"
  type        = string
}
