output "security_group_id" {
  description = "ID del Security Group"
  value       = aws_security_group.main.id
}

output "security_group_name" {
  description = "Nombre del Security Group"
  value       = aws_security_group.main.name
}
