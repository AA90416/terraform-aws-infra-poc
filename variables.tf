variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "az_count" {
  description = "Number of availability zones"
  type        = number
  default     = 2
}

variable "bastion_ami" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
}

variable "bastion_storage_size" {
  description = "Storage size in GB for the bastion host"
  type        = number
}

variable "asg_ami" {
  description = "AMI ID for the Auto Scaling Group instances"
  type        = string
}

variable "asg_instance_type" {
  description = "Instance type for Auto Scaling Group instances"
  type        = string
}

variable "asg_storage_size" {
  description = "Storage size in GB for Auto Scaling Group instances"
  type        = number
}

variable "asg_min_instance" {
  description = "Minimum number of instances for the ASG"
  type        = number
}

variable "asg_max_instance" {
  description = "Maximum number of instances for the ASG"
  type        = number
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_lifecycle_rules" {
  description = "List of S3 bucket lifecycle rules"
  type        = list(map(any))
}


variable "key_name" {
  description = "Name of the AWS Key Pair to be used for instances"
  type        = string
}

variable "backend_bucket" {
  description = "Name of the S3 bucket to store Terraform state."
}

variable "backend_key" {
  description = "Name of the Terraform state file in the S3 bucket."
}

variable "backend_region" {
  description = "AWS region of the S3 bucket and DynamoDB table."
}

variable "backend_dynamodb_table" {
  description = "Name of the DynamoDB table for state locking."
}
