resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-state-lock"
  hash_key = "LockID"
  read_capacity = 10
  write_capacity = 10

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
