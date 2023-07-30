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

variable "subnets" {
  description = "List of subnet IDs where ASG instances will be launched"
  type        = list(string)
}

variable "subnet_cidr_blocks" {
  type = list(string)
}

