output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "webserver_public_ips" {
  value = module.webserver.webserver_public_ips
}
