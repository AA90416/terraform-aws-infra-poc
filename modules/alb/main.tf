resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg"
  vpc_id      = var.vpc_id # Use the VPC ID of the same VPC as the ALB
  # Security group rules for allowing traffic on port 80 (HTTP)
  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    // Allow traffic from ALB security group or specific IP ranges
  }
  // Ingress rule for HTTPS (port 443)
  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    // Allow traffic from ALB security group or specific IP ranges
  } 
  // Ingress rule for SSH (port 22)
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    // Allow traffic from specific IP ranges that need SSH access
    cidr_blocks = ["0.0.0.0/0"] #["YOUR_PUBLIC_IP/32"]  # Replace with your public IP address
  }
  // Egress rule to allow any outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



#  ingress {
#    description = "HTTP Access"
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    # Allow traffic from specific IPs or ranges as needed
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}

resource "aws_alb" "alb" {
  name            = "my-alb"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         =   var.subnets
  #subnets     = var.private_subnets
  load_balancer_type = "application"
  tags = {
    Name = "ALB"
  }
}

resource "aws_alb_target_group" "asg_target_group" {
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
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

##################Test


resource "aws_security_group" "asg_sg" {
  name_prefix = "asg-sg-"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    // Allow traffic from ALB security group or specific IP ranges
  }
  // Ingress rule for HTTPS (port 443)
  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    // Allow traffic from ALB security group or specific IP ranges
  } 
  // Ingress rule for SSH (port 22)
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    // Allow traffic from specific IP ranges that need SSH access
    cidr_blocks = ["0.0.0.0/0"] #["YOUR_PUBLIC_IP/32"]  # Replace with your public IP address
  }
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
              sudo apt upgrade -y
              sudo apt update
              sudo apt install -y apache2
              sudo systemctl enable apache2
              sudo systemctl start apache2
              echo "Script executed successfully" > /var/log/user-data.log
              EOF
  security_groups = [aws_security_group.asg_sg.id] # Associate the security group with the instances
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
  target_group_arns   = [aws_alb_target_group.asg_target_group.arn]
  tag {
    key                 = "Name"
    value               = "ASGInstance"
    propagate_at_launch = true
  }
}

