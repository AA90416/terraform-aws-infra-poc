# terraform.tfvars
#allowed_ssh_ip = ["24.206.91.93/24"]
aws_region = "us-east-1"  #"us-east-1"
vpc_cidr = "10.1.0.0/16"
az_count = 2
bastion_ami = "ami-053b0d53c279acc90"
bastion_instance_type = "t2.micro"
bastion_storage_size = 20
ami = "ami-053b0d53c279acc90"
instance_type = "t2.small"
storage_size = 20
min_instance = 2
max_instance = 3 
instance_count = 2
#asg_ami = "ami-053b0d53c279acc90"
#asg_instance_type = "t2.micro"
#asg_storage_size = 20
#asg_min_instance = 2
#asg_max_instance = 6
backend_bucket          = "your-terraform-state-bucket"  # Replace with your unique S3 bucket name for storing Terraform state
backend_key             = "terraform.tfstate"           # Replace with a desired name for the Terraform state file
backend_region          = "us-east-1"                   # Replace with your desired AWS region
backend_dynamodb_table  = "terraform-lock"              # Replace with your desired name for the DynamoDB table (for state locking)
key_name = "poc-test"
bucket_name = "aws-terraform-poc-12234558373"


