
resource "aws_launch_configuration" "asg_lc" {
  name_prefix   = "asg-lc-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              EOF
}

resource "aws_autoscaling_group" "asg" {
  name                 = "my-asg"
  launch_configuration = aws_launch_configuration.asg_lc.name
  min_size             = var.instance_count
  max_size             = var.instance_count
  desired_capacity     = var.instance_count
  vpc_zone_identifier  = var.subnet_ids

  # Other ASG configuration as needed
}
