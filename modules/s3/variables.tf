variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the S3 bucket"
  type        = list(map(any))
}
