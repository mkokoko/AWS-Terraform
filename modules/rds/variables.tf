variable "allocated_storage" {
  type    = number
  default = 20
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "vpc_id" {}
variable "multi_az" {
  default = true
}

variable "port" {
  type    = number
  default = 3306
}

variable "database_name" {}
variable "database_username" {}
variable "subnet_ids" {}
variable "database_password" {}
variable "environment" {}
variable "db_subnet_group_name" {}

variable "ingress_security_group_ids" {
  type    = list(string)
  default = []
}
