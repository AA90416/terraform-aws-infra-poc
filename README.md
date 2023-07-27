# AWS Proof-of-Concept Environment with Terraform

## Overview
A company is planning to create a proof-of-concept environment in AWS using Terraform to manage their infrastructure via code. This README provides an outline of the proposed setup.

## VPC and Subnets
- 1 VPC with CIDR block: 10.1.0.0/16
- 4 subnets spread evenly across two availability zones:
   - Sub1 – 10.1.0.0/24 (accessible from the internet)
   - Sub2 – 10.1.1.0/24 (accessible from the internet)
   - Sub3 – 10.1.2.0/24 (not accessible from the internet)
   - Sub4 – 10.1.3.0/24 (not accessible from the internet)

## EC2 Instance
- 1 EC2 instance running Red Hat Linux in subnet Sub2
- Configuration:
  - Instance Type: t2.micro
  - Storage: 20 GB

## Auto Scaling Group (ASG)
- 1 Auto Scaling Group that spreads instances across subnets Sub3 and Sub4
- Configuration:
  - Instance Type: t2.micro
  - Storage: 20 GB
  - Number of Instances: Minimum 2, Maximum 6
- Scripted installation of Apache Web Server (httpd) on ASG instances

## Application Load Balancer (ALB)
- 1 Application Load Balancer (ALB) listening on TCP port 80 (HTTP)
- Forwards traffic to the ASG in subnets Sub3 and Sub4
- Security groups are used to allow necessary traffic

## S3 Bucket with Lifecycle Policies
- 1 S3 bucket with two folders:
  - "Images" folder: Move objects older than 90 days to Glacier.
  - "Logs" folder: Delete objects older than 90 days.

## How to Use the Terraform Code
1. Clone this repository to your local machine.
2. Navigate to the terraform/ directory.
3. Modify the variables in the `variables.tf` file to suit your requirements.
4. Run `terraform init` to initialize the Terraform environment.
5. Run `terraform plan` to preview the changes that will be applied.
6. Run `terraform apply` to create the AWS environment.

## Contact
For any further clarification or assistance, please reach out to the team at [rotero82@gmail.com].

---

