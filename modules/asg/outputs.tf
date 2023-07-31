output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "instance_count" {
  value = var.instance_count
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.asg.name
}
