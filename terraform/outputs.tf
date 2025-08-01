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

output "key_pair_name" {
  description = "Nombre del Key Pair creado en AWS"
  value       = aws_key_pair.vpn_key.key_name
}

output "ssh_connection_command" {
  description = "Comando para conectarse via SSH"
  value       = "ssh -i ~/.ssh/vpn-server-key ubuntu@${module.ec2.public_ip}"
}
