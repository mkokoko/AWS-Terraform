terraform {
  backend "s3" {
    bucket         = "terraform-state-task-mko"
    encrypt        = true
    region         = "us-east-2"
    key            = "terraform-common-infrastructure.tfstate"
    dynamodb_table = "terraform-helm-rnd-state-lock"
  }
}
