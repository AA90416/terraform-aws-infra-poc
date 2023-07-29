# modules/webserver/main.tf
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
  vpc_zone_identifier  = module.vpc.private_subnets # Use private subnets for ASG
}
