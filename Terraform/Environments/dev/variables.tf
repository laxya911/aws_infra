variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "create_vpc" {
  description = "Whether to create a new VPC"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ec2_key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
  default     = "dev-key"
}

variable "create_key_pair" {
  description = "Whether to create a new key pair"
  type        = bool
  default     = true
}

variable "public_key_file" {
  description = "Path to the public key file relative to this module"
  type        = string
  default     = "../../../secrets/ec2_key.pub"
}

variable "instances" {
  description = "Map of instance definitions"
  type = map(object({
    instance_type    = string
    root_volume_size = number
    tags             = map(string)
  }))
  default = {
    master = {
      instance_type    = "t2.medium"
      root_volume_size = 20
      tags             = { Role = "Master", App = "Jenkins-Nexus" }
    }
    worker-1 = {
      instance_type    = "t2.micro"
      root_volume_size = 10
      tags             = { Role = "Worker", App = "General" }
    }
  }
}

variable "ami_id" {
  description = "AMI ID for the instances"
  type        = string
  default     = "ami-0ecb62995f68bb549" # Ubuntu 20.04/22.04 default
}
