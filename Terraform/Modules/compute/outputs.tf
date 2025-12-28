output "instance_ids" {
  description = "Map of Instance IDs"
  value       = { for k, v in aws_instance.this : k => v.id }
}

output "public_ips" {
  description = "Map of Instance Public IPs"
  value       = { for k, v in aws_instance.this : k => v.public_ip }
}
