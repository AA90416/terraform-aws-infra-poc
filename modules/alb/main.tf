resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"
  vpc_id = aws_vpc.main.id  # Use the VPC ID of the same VPC as the ALB
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
