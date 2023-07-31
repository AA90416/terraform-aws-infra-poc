resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_alb" "alb" {
  name            = "my-alb"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.subnets
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

resource "aws_security_group" "asg_sg" {
  name_prefix = "asg-sg-"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Ingress rule for HTTPS (port 443)
  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
              EOF
  security_groups = [aws_security_group.asg_sg.id] # Associate the security group with the instances
}

resource "aws_autoscaling_group" "asg" {
  name                 = "my-asg"
  launch_configuration = aws_launch_configuration.asg_lc.name
  min_size             = var.min_instance
  max_size             = var.max_instance
  desired_capacity     = var.instance_count
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = [aws_alb_target_group.asg_target_group.arn]

  tag {
    key                 = "Name"
    value               = "ASGInstance"
    propagate_at_launch = true
  }
}
