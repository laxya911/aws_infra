output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.create_vpc ? aws_vpc.this[0].id : aws_default_vpc.default[0].id
}

output "subnet_id" {
  description = "The ID of the Subnet (if created)"
  value       = var.create_vpc ? aws_subnet.this[0].id : null
}
