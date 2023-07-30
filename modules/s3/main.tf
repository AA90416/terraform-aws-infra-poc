resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      id      = lifecycle_rule.value.id
      prefix  = lifecycle_rule.value.prefix

      dynamic "transition" {
        for_each = can(lifecycle_rule.value.transition) ? [lifecycle_rule.value.transition] : []
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = can(lifecycle_rule.value.expiration) ? [lifecycle_rule.value.expiration] : []
        content {
          days = expiration.value.days
        }
      }
    }
  }
}

terraform {
  experiments = [module_variable_optional_attrs]
}
