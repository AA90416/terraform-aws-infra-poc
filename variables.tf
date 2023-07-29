# variables.tf

variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "az_count" {
  description = "Number of availability zones"
  type        = number
}

variable "bastion_ami" {
  description = "The AMI ID for the Bastion host"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for Bastion host"
  type        = string
}

variable "bastion_storage_size" {
  description = "Storage size in GB for Bastion host"
  type        = number
}

variable "asg_ami" {
  description = "The AMI ID for the Auto Scaling Group instances"
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

variable "key_name" {
  description = "Name of the AWS Key Pair to be used for the bastion host"
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
