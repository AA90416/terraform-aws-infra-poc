
variable "security_group_ids" {
  description = "List of security group IDs attached to the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}


variable "subnet_id" {
  description = "ID of the subnet where the ASG instances will be launched"
  type        = string
}
