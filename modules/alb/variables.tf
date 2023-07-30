
variable "security_group_ids" {
  description = "List of security group IDs attached to the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be created."
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs where the ALB will be deployed."
  type        = list(string)
}

# "private_subnets" {
#  description = "List of private subnet IDs for the ALB"
#  type        = list(string)
#}
