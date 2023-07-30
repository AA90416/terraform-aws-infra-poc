resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  lifecycle_rule {
    id      = "images_rule"
    prefix  = "Images/"
    status  = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "logs_rule"
    prefix  = "Logs/"
    status  = "Enabled"

    expiration {
      days = 90
    }
  }
}
