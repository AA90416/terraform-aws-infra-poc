variable "subnets" {
  description = "List of subnet IDs where ALB will be created"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs attached to the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "asg_instance_type" {
  description = "Instance type for the Auto Scaling Group (ASG) instances"
  type        = string
}

variable "asg_ami" {
  description = "ID of the Amazon Machine Image (AMI) to be used for the ASG instances"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to be created in the ASG"
  type        = number
}

variable "subnet_id" {
  description = "ID of the subnet where the ASG instances will be launched"
  type        = string
}
