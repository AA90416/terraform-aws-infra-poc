# backend.tf

terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"  # Replace with your unique S3 bucket name for storing Terraform state
    key            = "terraform.tfstate"           # Replace with a desired name for the Terraform state file
    region         = "us-east-1"                   # Replace with your desired AWS region
  }
}
