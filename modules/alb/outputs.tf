output "dns_name" {
  value = aws_alb.alb.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "subnet_ids" {
  value = aws_subnet.my_subnets.*.id
}
