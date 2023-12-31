# terraform.tfvars
aws_region = "us-east-1"
vpc_cidr = "10.1.0.0/16"
bastion_ami = "ami-026ebd4cfe2c043b2"
bastion_instance_type = "t2.micro"
instance_type  = "t2.micro"
bastion_storage_size = 20
backend_bucket          = "your-terraform-state-bucket"  # Replace with your unique S3 bucket name for storing Terraform state
backend_key             = "terraform.tfstate"           # Replace with a desired name for the Terraform state file
backend_region          = "us-east-1"                   # Replace with your desired AWS region
backend_dynamodb_table  = "terraform-lock"              # Replace with your desired name for the DynamoDB table (for state locking)
bucket_name = "aws-terraform-poc-12234558373"
## Pem key created in AWS to access the bastion host.
key_name = "poc-test"
## AWS ami image id for the Webservers.
ami = "ami-026ebd4cfe2c043b2"
