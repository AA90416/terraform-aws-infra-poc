# terraform.tfvars

aws_region = "us-east-1"
vpc_cidr = "10.1.0.0/16"
az_count = 2
bastion_ami = "ami-026ebd4cfe2c043b2"
bastion_instance_type = "t2.micro"
bastion_storage_size = 20
asg_ami = "ami-026ebd4cfe2c043b2"
asg_instance_type = "t2.micro"
asg_storage_size = 20
asg_min_instance = 2
asg_max_instance = 6
backend_bucket          = "your-terraform-state-bucket"  # Replace with your unique S3 bucket name for storing Terraform state
backend_key             = "terraform.tfstate"           # Replace with a desired name for the Terraform state file
backend_region          = "us-east-1"                   # Replace with your desired AWS region
backend_dynamodb_table  = "terraform-lock"              # Replace with your desired name for the DynamoDB table (for state locking)
key_name = "dev-key-terraform"
s3_bucket_name = "your_unique_bucket_name"
s3_lifecycle_rules = [
  {
    id          = "images_rule"
    prefix      = "Images/"
    status      = "Enabled"
    tags = {
      Name = "Images Rule"
    }
    transitions = [
      {
        days          = 90
        storage_class = "GLACIER"
      }
    ]
    expiration = {}
  },
  {
    id          = "logs_rule"
    prefix      = "Logs/"
    status      = "Enabled"
    tags = {
      Name = "Logs Rule"
    }
    transitions = []
    expiration = {
      days = 90
    }
  }
]

