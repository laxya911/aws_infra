variable "environment" {
  description = "Environment name"
  type        = string
}

variable "create_vpc" {
  description = "Whether to create a new VPC"
  type        = bool
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}
