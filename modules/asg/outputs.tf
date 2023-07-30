output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "instance_count" {
  value = var.instance_count
}
#output "instance_type" {
#  description = "The instance type used for the Auto Scaling Group."
#  value       = aws_launch_configuration.asg_lc.instance_type
#}

#output "ami" {
#  description = "The AMI ID used for the Auto Scaling Group instances."
#  value       = aws_launch_configuration.asg_lc.image_id
#}

#output "instance_count" {
#  description = "The number of instances in the Auto Scaling Group."
#  value       = length(aws_autoscaling_group.asg)
#}


#output "subnet_ids" {
#  description = "The list of subnet IDs where Auto Scaling Group instances are deployed."
#h  value       = aws_autoscaling_group.asg.vpc_zone_identifier
#}
