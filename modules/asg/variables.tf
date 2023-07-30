variable "key_name" {
  description = "Name of the AWS Key Pair to be used for instances in the ASG"
  type        = string
}

variable "ami" {
  description = "The AMI ID for the Auto Scaling Group instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for Auto Scaling Group instances"
  type        = string
}

variable "storage_size" {
  description = "Storage size in GB for Auto Scaling Group instances"
  type        = number
}

variable "min_instance" {
  description = "Minimum number of instances for the ASG"
  type        = number
}

variable "max_instance" {
  description = "Maximum number of instances for the ASG"
  type        = number
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "subnet_ids" {
  description = "List of subnet IDs where ASG instances will be launched"
  type        = list(string)
}

variable "instance_count" {
  description = "Number of instances to launch in the ASG"
  type        = number
  default     = 1
}
#variable "subnets" {
#  description = "List of subnet IDs where ASG instances will be launched"
#  type        = list(string)
#}

#variable "subnet_cidr_blocks" {
#  type = list(string)
#}

variable "allowed_ssh_ip" {
  description = "Single CIDR block to allow SSH access"
  type        = string
  default     = "203.0.113.0/24" # Replace with your actual CIDR block
}

