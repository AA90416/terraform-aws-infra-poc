output "asg_name" {
  value = aws_autoscaling_group.asg.name
}
output "security_group_id" {
  value = aws_security_group.http_ssh.id
}
