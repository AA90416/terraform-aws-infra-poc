output "webserver_public_ips" {
  value = aws_autoscaling_group.webserver_asg.*.instances[*].public_ip
}
