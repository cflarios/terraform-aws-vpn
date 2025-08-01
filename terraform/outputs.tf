# Outputs principales
output "instance_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = module.ec2.public_ip
}

output "instance_public_dns" {
  description = "DNS público de la instancia EC2"
  value       = module.ec2.public_dns
}

output "instance_id" {
  description = "ID de la instancia EC2"
  value       = module.ec2.instance_id
}

output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.vpc.vpc_id
}

output "security_group_id" {
  description = "ID del Security Group"
  value       = module.security_group.security_group_id
}

output "ssh_connection_command" {
  description = "Comando para conectarse via SSH (requiere key pair)"
  value       = var.key_name != null ? "ssh -i ${var.key_name}.pem ubuntu@${module.ec2.public_ip}" : "Key pair no configurado"
}
