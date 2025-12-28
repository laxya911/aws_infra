variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "ec2_key_name" {
  description = "Name of the Key Pair"
  type        = string
}

variable "public_key" {
  description = "Public key material for creating the Key Pair"
  type        = string
  default     = ""
}

variable "create_key_pair" {
  description = "Whether to create a new Key Pair"
  type        = bool
  default     = true
}
