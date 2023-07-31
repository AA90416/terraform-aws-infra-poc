# AWS Proof-of-Concept Environment with Terraform

## Overview
A company is planning to create a proof-of-concept environment in AWS using Terraform to manage their infrastructure via code. This Terraform project sets up a VPC with public and private subnets, deploys EC2 instances, configures Auto Scaling, creates an Application Load Balancer (ALB), and sets up an S3 bucket with lifecycle policies for data management.

## Components

### VPC and Subnets
- 1 VPC with CIDR block: 10.1.0.0/16
- 4 subnets spread evenly across two availability zones:
   - Sub1 – 10.1.0.0/24 (accessible from the internet)
   - Sub2 – 10.1.1.0/24 (accessible from the internet)
   - Sub3 – 10.1.2.0/24 (not accessible from the internet)
   - Sub4 – 10.1.3.0/24 (not accessible from the internet)

### EC2 Instance
- 1 EC2 instance running Red Hat Linux in subnet Sub2
- Configuration:
  - Instance Type: t2.micro
  - Storage: 20 GB

### Auto Scaling Group (ASG)
- 1 Auto Scaling Group that spreads instances across subnets Sub3 and Sub4
- Configuration:
  - Instance Type: t2.micro
  - Storage: 20 GB
  - Number of Instances: Minimum 2, Maximum 6
- Scripted installation of Apache Web Server (httpd) on ASG instances

### Application Load Balancer (ALB)
- 1 Application Load Balancer (ALB) listening on TCP port 80 (HTTP)
- Forwards traffic to the ASG in subnets Sub3 and Sub4
- Security groups are used to allow necessary traffic

### S3 Bucket with Lifecycle Policies
- 1 S3 bucket with two folders:
  - "Images" folder: Move objects older than 90 days to Glacier.
  - "Logs" folder: Delete objects older than 90 days.


### How the Code Works
VPC and Subnets (modules/vpc/main.tf): The Terraform code defines a VPC (Virtual Private Cloud) with a specified CIDR block (10.1.0.0/16). It creates four subnets across two availability zones: Sub1, Sub2, Sub3, and Sub4. Subnets Sub1 and Sub2 are public, accessible from the internet, while Sub3 and Sub4 are private, not accessible from the internet.

EC2 Instance (modules/webserver/main.tf): The code provisions an EC2 instance running Red Hat Linux in Subnet Sub2 (public). It uses the t2.micro instance type with a 20GB storage volume.

Auto Scaling Group (modules/webserver/main.tf): An Auto Scaling Group (ASG) is created to manage the number of EC2 instances. The ASG spans Subnets Sub3 and Sub4 (private subnets). It maintains the desired number of instances between a minimum of 2 and a maximum of 6 t2.micro instances.

User Data (modules/bastion/main.tf and modules/webserver/main.tf): In the Terraform EC2 instance resource blocks for both the bastion and web server instances, user data scripts are provided. These scripts are executed when the instances are launched and perform initial configurations. Specifically, the scripts update the system packages, install the Apache HTTP server (httpd), enable and start the httpd service, and configure firewall rules to allow the necessary traffic.

Application Load Balancer (ALB) (modules/webserver/main.tf): An Application Load Balancer is created, listening on TCP port 80 (HTTP). The ALB forwards incoming traffic to the instances in Subnets Sub3 and Sub4 managed by the ASG. Security groups are used to allow necessary traffic.

S3 Bucket with Lifecycle Policies (modules/s3_bucket/main.tf): The code creates an S3 bucket with a specified bucket name. The bucket contains two folders: "Images" and "Logs." A lifecycle policy is applied to the bucket. Objects in the "Images" folder older than 90 days are moved to the Glacier storage class, while objects in the "Logs" folder older than 90 days are automatically deleted. This lifecycle policy helps manage data storage and cost optimization.

How to Use the Terraform Code: To set up the environment, clone this repository, navigate to the terraform/ directory, modify the variables.tf file to adjust the settings as needed, and run terraform init, terraform plan, and terraform apply to create the AWS environment. The code handles the infrastructure creation, and the instances will be provisioned, configured, and managed based on the specified settings.

Clean Up: To remove the created infrastructure, run terraform destroy -var aws_region="us-east-1". This will clean up all the resources created by Terraform and ensure no unwanted charges occur on your AWS account.

With this Terraform code, the AWS Proof-of-Concept Environment will be set up and ready for use. The environment includes a VPC, EC2 instances, Auto Scaling, Application Load Balancer, and an S3 bucket with lifecycle policies, all managed and configured automatically by Terraform.

## User Data script init_webserver.sh
In the Terraform EC2 instance resource block for the bastion web server instances, we provide user data to execute script-based configurations. The user data scripts perform the following tasks:

- Update the system packages
- Install Apache HTTP server (httpd)
- Enable and start the httpd service
- Configure firewall rules to allow the necessary traffic
- Set up HTML weblanding page

Please make sure to add the correct user data scripts in the respective Terraform resource blocks.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine (>= v0.12, < v0.14).
- AWS IAM user credentials with sufficient permissions to create the infrastructure resources.

## How to Use the Terraform Code
1. Clone this repository to your local machine.
3. Navigate to the terraform/ directory. 
4. Modify the variables in the `terraform.tfvars` file to suit your requirements.
5. Make the userdata.sh files executable using chmod +x init_webserver.sh before using the script in Terraform.
7. Run `terraform init` to initialize the Terraform environment.
8. Run `terraform plan -var-file="terraform.tfvars"` to preview the changes that will be applied.
9. Run `terraform apply -var-file="terraform.tfvars"` to create the AWS environment.

## Clean Up
To remove the created infrastructure, run:  terraform destroy -var-file="terraform.tfvars

## Contact
For any further clarification or assistance, please reach out to the team at [rotero82@gmail.com].

## License
This project is licensed under the [MIT License](LICENSE).
---
