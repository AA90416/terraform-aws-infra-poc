resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  for_each = { for idx, rule in var.lifecycle_rules : idx => rule }

  lifecycle_rule {
    id     = each.value.id
    prefix = each.value.prefix
    status = each.value.status

    dynamic "transition" {
      for_each = can(each.value.transition) ? [1] : []
      content {
        days          = each.value.transition.days
        storage_class = each.value.transition.storage_class
      }
    }

    dynamic "expiration" {
      for_each = can(each.value.expiration) ? [1] : []
      content {
        days = each.value.expiration.days
      }
    }
  }
}
