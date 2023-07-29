variable "subnets" {
  description = "List of subnet IDs where ALB will be created"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs attached to the ALB"
  type        = list(string)
}
