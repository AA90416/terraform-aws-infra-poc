resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  # Lifecycle rules for S3 bucket
  lifecycle_rule {
    id      = "images_rule"
    prefix  = "Images/"
    status  = "Enabled"
    transitions = [
      {
        days          = 90
        storage_class = "GLACIER"
      }
    ]
  }

  lifecycle_rule {
    id      = "logs_rule"
    prefix  = "Logs/"
    status  = "Enabled"
    expiration = {
      days = 90
    }
  }
}
