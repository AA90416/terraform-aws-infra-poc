
# "aws_launch_configuration" "asg_lc" {
#  name_prefix   = "asg-lc"
#  image_id      = var.ami
#  instance_type = var.instance_type
#  key_name      = var.key_name

resource "aws_launch_configuration" "asg_lc" {
  name_prefix   = "asg-lc"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y apache2
              sudo systemctl enable apache2
              sudo systemctl start apache2
              EOF
  tags = {
    Name = "WebServer"
  }
}
  #user_data = <<-EOF
  #            #!/bin/bash
  #            sudo yum update -y
  #            sudo yum install -y httpd
  #            sudo systemctl enable httpd
  #            sudo systemctl start httpd
  #            EOF
#}

resource "aws_autoscaling_group" "asg" {
  name                 = "my-asg"
  launch_configuration = aws_launch_configuration.asg_lc.name
  min_size             = var.min_instance
  max_size             = var.max_instance
  desired_capacity     = var.instance_count
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "ASGInstance"
    propagate_at_launch = true
  }
}
