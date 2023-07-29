resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  # Add the following lifecycle configuration
  lifecycle_rule {
    id      = "glacier_rule"
    status  = "Enabled"
    prefix  = "Images/"
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "delete_logs_rule"
    status  = "Enabled"
    prefix  = "Logs/"
    expiration {
      days = 90
    }
  }
}
