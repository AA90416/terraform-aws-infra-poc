module "vpc" {
  source  = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  az_count = var.az_count
}

# Define the data source to get the availability zones in the selected region
data "aws_availability_zones" "available" {
  state = "available"
}

# Define the EIP resource for the NAT gateways
resource "aws_eip" "nat" {
  count = var.az_count
}

module "bastion" {
  source        = "./modules/bastion"
  subnet_id     = module.vpc.public_subnets[1]
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type
#  storage_size  = var.bastion_storage_size
  key_name      = var.key_name #aws_key_pair.example_keypair.key_name
}

module "asg" {
  source          = "./modules/asg"
  subnets         = module.vpc.private_subnets
  ami             = var.asg_ami
  instance_type   = var.asg_instance_type
  storage_size    = var.asg_storage_size
  min_instance    = var.asg_min_instance
  max_instance    = var.asg_max_instance
  key_name        = var.key_name #aws_key_pair.example_keypair.key_name
}

module "alb" {
  source        = "./modules/alb"
  vpc_id        = module.vpc.vpc_id
  subnets       = module.vpc.private_subnets
  security_group_ids = [module.bastion.security_group_id]
}

module "s3" {
  source       = "./modules/s3"
  bucket_name  = var.s3_bucket_name
  lifecycle_rules = var.s3_lifecycle_rules
}

module "webserver" {
  source              = "./modules/webserver"
  subnets             = module.vpc.private_subnets
  security_group_ids  = [module.alb.security_group_id]
  webserver_ami       = var.webserver_ami
  webserver_instance_type = var.webserver_instance_type
  webserver_key_pair  = var.key_name
  webserver_instance_count = 2  # Example value, adjust as needed
}
