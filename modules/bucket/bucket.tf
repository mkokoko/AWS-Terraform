resource "aws_s3_bucket" "versioning-bucket" {
  bucket = var.bucket_name
  acl    = var.bucket_acl
  region = var.aws_region
  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = var.bucket_storage_class
      # or "ONEZONE_IA"
    }
  }
  versioning {
    enabled = var.bucket_versioning
  }
}
