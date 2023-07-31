
# "aws_launch_configuration" "asg_lc" {
#  name_prefix   = "asg-lc"
#  image_id      = var.ami
#  instance_type = var.instance_type
#  key_name      = var.key_name

resource "aws_security_group" "asg_sg" {
  name_prefix = "asg-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip] # List your public IP address or range to allow SSH
  }
}

resource "aws_launch_configuration" "asg_lc" {
  name_prefix   = "asg-lc"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y apache2
              sudo systemctl enable apache2
              sudo systemctl start apache2
              EOF
  security_groups = [aws_security_group.asg_sg.id] # Associate the security group with the instances
}

resource "aws_autoscaling_attachment" "alb_attachment" {
  autoscaling_group_name = module.asg.this_autoscaling_group_name
  alb_target_group_arn   = aws_alb_target_group.asg_target_group.arn
}
  #user_data = <<-EOF
  #            #!/bin/bash
  #            sudo yum update -y
  #            sudo yum install -y httpd
  #            sudo systemctl enable httpd
  #            sudo systemctl start httpd
  #            EOF
#}

resource "aws_autoscaling_group" "asg" {
  name                 = "my-asg"
  launch_configuration = aws_launch_configuration.asg_lc.name
  min_size             = var.min_instance
  max_size             = var.max_instance
  desired_capacity     = var.instance_count
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "ASGInstance"
    propagate_at_launch = true
  }
}
