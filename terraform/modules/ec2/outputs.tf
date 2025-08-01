output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Dirección IP pública de la instancia"
  value       = aws_instance.main.public_ip
}

output "public_dns" {
  description = "DNS público de la instancia"
  value       = aws_instance.main.public_dns
}

output "private_ip" {
  description = "Dirección IP privada de la instancia"
  value       = aws_instance.main.private_ip
}
