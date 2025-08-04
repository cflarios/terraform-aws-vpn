# Main outputs
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = module.ec2.public_dns
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.instance_id
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.security_group.security_group_id
}

output "key_pair_name" {
  description = "Name of the Key Pair created in AWS"
  value       = aws_key_pair.vpn_key.key_name
}

output "ssh_connection_command" {
  description = "Command to connect via SSH"
  value       = "ssh -i ~/.ssh/vpn-server-key ubuntu@${module.ec2.public_ip}"
}
