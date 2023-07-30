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

#variable "bastion_storage_size" {
#  description = "Storage size in GB for Bastion host"
#  type        = number
#}

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

variable "s3_lifecycle_rules" {
  description = "List of lifecycle rules for the S3 bucket"
  type        = list(map(string))
}

variable "webserver_ami" {
  description = "The AMI ID for the webserver instances"
  type        = string
}

variable "webserver_instance_type" {
  description = "Instance type for webserver instances"
  type        = string
}

variable "webserver_instance_count" {
  description = "Number of webserver instances in the Auto Scaling Group"
  type        = number
}
/modules/vpc/main.tf:
hcl
Copy code
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "public" {
  count = var.az_count

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 4)  # Use count.index + 4 to avoid overlapping with public subnet CIDRs

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public" {
  count = var.az_count

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "nat" {
  count = var.az_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name = "NAT Gateway ${count.index + 1}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route" "nat_gateway" {
  count = var.az_count

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private" {
  count = var.az_count

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
/modules/vpc/outputs.tf:
hcl
Copy code
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}
/modules/vpc/variables.tf:
hcl
Copy code
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "az_count" {
  description = "Number of availability zones"
  type        = number
}
/modules/bastion/main.tf:
hcl
Copy code
resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_security_group" "http_ssh" {
  name_prefix = "http-ssh-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/modules/bastion/outputs.tf:
hcl
Copy code
output "bastion_public_ip" {
  description = "Public IP address of the bastion host."
  value       = aws_instance.bastion.public_ip
}

output "security_group_id" {
  value = aws_security_group.http_ssh.id
}
/modules/bastion/variables.tf:
hcl
Copy code
variable "ami" {
  description = "The AMI ID for the Bastion host"
  type        = string
}

variable "instance_type" {
  description = "Instance type for Bastion host"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet in which the Bastion host will be launched"
  type        = string
}

variable "key_name" {
  description = "Name of the AWS Key Pair to be used for the bastion host"
  type        = string
}
/modules/asg/main.tf:
hcl
Copy code
resource "aws_launch_configuration" "asg_lc" {
  name_prefix   = "asg-lc-"
  image_id      = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.http_ssh.id]
  key_name      = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              EOF
}

resource "aws_autoscaling_group" "asg" {
  name                 = "my-asg"
  launch_configuration = aws_launch_configuration.asg_lc.name
  min_size             = var.min_instance
  max_size             = var.max_instance
  desired_capacity     = var.min_instance
  vpc_zone_identifier  = var.subnets
}
/modules/asg/outputs.tf:
hcl
Copy code
output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "security_group_id" {
  value = aws_security_group.http_ssh.id
}
/modules/asg/variables.tf:
hcl
Copy code
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
/modules/alb/main.tf:
hcl
Copy code
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"

  # Security group rules for allowing traffic on port 80 (HTTP)
  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Allow traffic from specific IPs or ranges as needed
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "alb" {
  name            = "my-alb"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.subnets

  tags = {
    Name = "ALB"
  }
}

resource "aws_alb_target_group" "asg_target_group" {
  name        = "asg-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_alb_target_group_attachment" "asg_attachment" {
  target_group_arn = aws_alb_target_group.asg_target_group.arn
  target_id        = aws_instance.asg.*.id
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.asg_target_group.arn
    type             = "forward"
  }
}
/modules/alb/outputs.tf:
hcl
Copy code
output "dns_name" {
  value = aws_alb.alb.dns_name
}
/modules/alb/variables.tf:
hcl
Copy code
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
/modules/s3/main.tf:
hcl
Copy code
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  # Lifecycle rules for S3 bucket
  lifecycle_rule {
    id      = "images_rule"
    prefix  = "Images/"
    status  = "Enabled"
    transitions = [
      {
        days          = 90
        storage_class = "GLACIER"
      }
    ]
  }

  lifecycle_rule {
    id      = "logs_rule"
    prefix  = "Logs/"
    status  = "Enabled"
    expiration = {
      days = 90
    }
  }
}
/modules/s3/outputs.tf:
hcl
Copy code
output "bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}
/modules/s3/variables.tf:
hcl
Copy code
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the S3 bucket"
  type        = list(map(string))
}
/modules/webserver/main.tf:
hcl
Copy code
resource "aws_security_group" "webserver_sg" {
  name_prefix = "webserver-sg"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "webserver_lc" {
  name_prefix            = "webserver-lc-"
  image_id               = var.webserver_ami
  instance_type          = var.webserver_instance_type
  key_name               = var.webserver_key_pair
  security_groups        = [aws_security_group.webserver_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # User data script to install Apache HTTP on the web server
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
}

resource "aws_autoscaling_group" "webserver_asg" {
  name                 = "webserver-asg"
  launch_configuration = aws_launch_configuration.webserver_lc.name
  min_size             = var.webserver_instance_count
  max_size             = var.webserver_instance_count
  desired_capacity     = var.webserver_instance_count
  vpc_zone_identifier  = var.subnets
}
/modules/webserver/outputs.tf:
hcl
Copy code
output "webserver_public_ips" {
  value = aws_autoscaling_group.webserver_asg.*.instances[*].public_ip
}
/modules/webserver/variables.tf:
hcl
Copy code
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
