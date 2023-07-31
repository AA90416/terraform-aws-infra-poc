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
  key_name      = var.key_name 
  vpc_id      = module.vpc.vpc_id
}

#module "asg" {
#  source          = "./modules/asg"
#  vpc_id          = module.vpc.vpc_id
#  subnet_ids     = module.vpc.private_subnets
#  ami             = var.ami
#  instance_type   = var.instance_type
#  storage_size    = var.storage_size
#  min_instance    = var.min_instance
#  max_instance    = var.max_instance
#  key_name        = var.key_name 
#  instance_count    = var.instance_count
#}


module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  subnets           = module.vpc.public_subnets
  security_group_ids = [module.bastion.security_group_id]
########asg config
  subnet_ids     = module.vpc.private_subnets
  ami             = var.ami
  instance_type   = var.instance_type
  storage_size    = var.storage_size
  min_instance    = var.min_instance
  max_instance    = var.max_instance
  key_name        = var.key_name 
  instance_count    = var.instance_count
}



#module "alb" {
#  source        = "./modules/alb"
#  vpc_id        = module.vpc.vpc_id
#  subnets       = module.vpc.private_subnets
#  security_group_ids = [module.bastion.security_group_id]
#}

module "s3" {
  source          = "./modules/s3"
  bucket_name     = var.bucket_name
  lifecycle_rules = [
    {
      id      = "images_rule"
      prefix  = "Images/"
      status  = "Enabled"
      transition = {
        days          = 90
        storage_class = "GLACIER"
      }
    },
    {
      id      = "logs_rule"
      prefix  = "Logs/"
      status  = "Enabled"
      expiration = {
        days = 90
      }
    }
  ]
}
