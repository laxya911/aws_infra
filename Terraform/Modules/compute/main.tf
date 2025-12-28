resource "aws_instance" "this" {
  for_each = var.instances

  ami           = var.ami_id
  instance_type = each.value.instance_type
  key_name      = var.key_name

  # If subnet_id is null, it launches in the default subnet of the default VPC (if utilizing default VPC)
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  user_data = var.user_data

  root_block_device {
    encrypted             = true
    delete_on_termination = true
    volume_size           = each.value.root_volume_size
    volume_type           = "gp2"
    tags = {
      Name = "${each.key}-root-vol"
    }
  }

  tags = merge(
    {
      Name        = "${var.environment}-${each.key}"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    each.value.tags
  )
}
