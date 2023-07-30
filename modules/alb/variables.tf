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
