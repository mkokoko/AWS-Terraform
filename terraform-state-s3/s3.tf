resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state"
  acl    = "private"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}
