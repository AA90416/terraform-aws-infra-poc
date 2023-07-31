output "dns_name" {
  value = aws_alb.alb.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "asg_target_group_arn" {
  value = aws_alb_target_group.asg_target_group.arn
}
