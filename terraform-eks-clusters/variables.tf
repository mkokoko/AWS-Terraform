# TODO: This variable should be global to all terraform environments
variable "project_name" {
  default = "helm-rnd"
}
variable "redis_cluster_name" {
  default = "dev"
}
# This is environment specific name, should reference terraform workspace name
variable "eks_cluster_name" {
  default = "dev"
}

variable "aws_region" {
  default = "us-east-2"
}
variable "bucket_name" {
  default = "bucket"
}
variable "vpc_public_subnets" {
  default = ["10.0.201.0/24", "10.0.202.0/24"]
}
variable "vpc_private_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}
variable "availability_zone" {
  default = ["us-east-2a", "us-east-2b", ]
}
variable "database_name" {
  default = "blog"
}
variable "database_username" {
  default = "admin"
}
variable "database_password" {
  default = "admin123"
}
