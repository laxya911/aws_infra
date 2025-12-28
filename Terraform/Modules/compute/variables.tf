variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instances" {
  description = "Map of instance definitions"
  type = map(object({
    instance_type    = string
    root_volume_size = number
    tags             = map(string)
  }))
}

variable "ami_id" {
  description = "AMI ID for the instances"
  type        = string
}

variable "key_name" {
  description = "SSH Key Pair name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch in"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of Security Group IDs"
  type        = list(string)
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = null
}
