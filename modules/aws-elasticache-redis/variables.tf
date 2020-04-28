variable "name" {}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "environment" {}

variable "ingress_security_group_ids" {
  type    = list(string)
  default = []
}

variable "port" {
  type    = number
  default = 6379
}

variable "node_type" {
  type    = string
  default = "cache.t3.micro"
}
