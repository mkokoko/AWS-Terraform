terraform {
  backend "s3" {
    bucket         = "terraform-state"
    encrypt        = true
    region         = "us-east-2"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
  }
}
