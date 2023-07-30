variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "lifecycle_rules" {
  type = list(map(any))
  default = [
    {
      id      = "images_rule"
      prefix  = "Images/"
      status  = "Enabled"
      transition = {
        days          = 90
        storage_class = "GLACIER"
      }
      expiration = {}
    },
    {
      id      = "logs_rule"
      prefix  = "Logs/"
      status  = "Enabled"
      transition = {}
      expiration = {
        days = 90
      }
    }
  ]
}



