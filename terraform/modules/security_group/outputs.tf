output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.main.id
}

output "security_group_name" {
  description = "Security Group name"
  value       = aws_security_group.main.name
}
