resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  lifecycle_rule {
    id      = "images_rule"
    status  = "Enabled"
    prefix  = "Images/"
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "logs_rule"
    status  = "Enabled"
    prefix  = "Logs/"
    expiration {
      days = 90
    }
  }
}
