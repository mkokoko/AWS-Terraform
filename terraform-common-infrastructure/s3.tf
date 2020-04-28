resource "aws_s3_bucket" "charts" {
  bucket = "helm-rnd"
  acl    = "private"
  versioning {
    enabled = false
  }
}
