output "security_group_id" {
  description = "ID of the created Security Group"
  value       = aws_security_group.allow_ssh_http.id
}

output "key_name" {
  description = "Name of the Key Pair used"
  value       = var.create_key_pair ? aws_key_pair.ec2_key[0].key_name : var.ec2_key_name
}
