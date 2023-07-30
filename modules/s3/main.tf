# modules/s3/main.tf

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  rule {
    id      = "images_rule"
    status  = "Enabled"
    prefix  = "Images/"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id      = "logs_rule"
    status  = "Enabled"
    prefix  = "Logs/"

    expiration {
      days = 90
    }
  }

  bucket = var.bucket_name
}


#resource "aws_s3_bucket" "s3_bucket" {
#  bucket = var.bucket_name
#  acl    = "private"
#  lifecycle_rule {
#    id      = "images_rule"
#    prefix  = "Images/"
#    enabled = true  # Enable this lifecycle rule
#
#    transition {
#      days          = 90
#      storage_class = "GLACIER"
#    }
#  }

#  lifecycle_rule {
#    id      = "logs_rule"
#    prefix  = "Logs/"
#    enabled = true  # Enable this lifecycle rule
#
#    expiration {
#      days = 90
#    }
#  }
#}


terraform {
  experiments = [module_variable_optional_attrs]
}
