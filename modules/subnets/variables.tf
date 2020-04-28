variable "vpc_private_subnets" {}
variable "vpc_private_subnet_name" {}
variable "private_subnet_type" {}
variable "vpc_id" {}
variable "vpc_name" {}
variable "igw_name" {}
variable "vpc_public_subnets" {}
variable "vpc_public_subnet_name" {}
variable "public_subnet_type" {}
variable "availability_zone" {}
variable "public_subnet_additional_tags" {
  type    = map
  default = {}
}
variable "private_subnet_additional_tags" {
  type    = map
  default = {}
}
