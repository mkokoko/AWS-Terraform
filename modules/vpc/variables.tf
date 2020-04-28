variable "vpc_name" {}
variable "vpc_cidr" {}
variable "vpc_additional_tags" {
  type    = map
  default = {}
}
