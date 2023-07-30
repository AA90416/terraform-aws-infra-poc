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

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  for_each = { for idx, rule in var.lifecycle_rules : idx => rule }

  lifecycle_rule {
    id     = each.value.id
    prefix = each.value.prefix
    status = each.value.status

    dynamic "transition" {
      for_each = can(each.value.transition) ? [each.value.transition] : []
      content {
        days          = transition.value.days
        storage_class = transition.value.storage_class
      }
    }

    dynamic "expiration" {
      for_each = can(each.value.expiration) ? [each.value.expiration] : []
      content {
        days = expiration.value.days
      }
    }
  }
}




