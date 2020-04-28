variable "redis_name" {}
variable "redis_subnet_ids" {}
variable "environment" {}
variable "vpc_id" {}
variable "node_groups" {
  description = "Number of nodes groups to create in the cluster"
  default     = 1
}

variable "ingress_security_group_ids" {
  type    = list
  default = []
}
