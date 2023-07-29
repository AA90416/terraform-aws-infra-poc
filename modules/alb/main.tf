resource "aws_alb" "alb" {
  name               = "my-alb"
  subnets            = var.subnets
  security_groups    = var.security_group_ids
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.asg_target_group.arn
  }
}

resource "aws_alb_target_group" "asg_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id
}

resource "aws_alb_target_group_attachment" "asg_attachment" {
  target_group_arn = aws_alb_target_group.asg_target_group.arn
  target_id        = aws_instance.asg.*.id
  port             = 80
}

data "aws_vpc" "selected" {
  default = true
}

output "dns_name" {
  value = aws_alb.alb.dns_name
}
