
variable "ami"{
 type = string
  default = "ami-010aff33ed5991201"
}
variable "key_name"{
  type = string
  default = "MY-TEMP-PVT-INSTANCE"
}

variable "instance_type" {
  description = "The EC2 instance type to be used in the launch configuration."
  type        = string
  default     = "t2.micro"  # You can set a default value or leave it unset if you want to require explicit input.
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "default region"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.1.0.0/16"
  description = "default vpc_cidr_block"
}

variable "pub_sub1_cidr_block"{
   type        = string
   default     = "10.1.0.0/24"
}

variable "pub_sub2_cidr_block"{
   type        = string
   default     = "10.1.1.0/24"
}
variable "prv_sub1_cidr_block"{
   type        = string
   default     = "10.1.2.0/24"
}
variable "prv_sub2_cidr_block"{
   type        = string
   default     = "10.1.3.0/24"
}


variable "sg_name"{
 type = string
 default = "alb_sg"
}

variable "sg_description"{
 type = string
 default = "SG for application load balancer"
}

variable "sg_tagname"{
 type = string
 default = "SG for ALB"
}

variable "sg_ws_name"{
 type = string
 default = "webserver_sg"
}

variable "sg_ws_description"{
 type = string
 default = "SG for web server"
}

variable "sg_ws_tagname"{
 type = string
 default = "SG for web"
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


variable "bucket_name" {
  description = "Name of the S3 bucket"
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
