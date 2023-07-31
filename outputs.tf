output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}


output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}


# Output the ALB DNS name
output "load_balancer_dns" {
  value = data.aws_lb.ALB.dns_name
}
