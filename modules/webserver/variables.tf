variable "subnets" {
  description = "List of subnet IDs where webserver instances will be launched"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs attached to the webserver instances"
  type        = list(string)
}

variable "webserver_ami" {
  description = "The AMI ID for the webserver instances"
  type        = string
}

variable "webserver_instance_type" {
  description = "Instance type for webserver instances"
  type        = string
}

variable "webserver_key_pair" {
  description = "Name of the AWS Key Pair to be used for instances in the ASG"
  type        = string
}

variable "webserver_instance_count" {
  description = "Number of webserver instances in the Auto Scaling Group"
  type        = number
}
