variable "eks_name" {}
variable "public_subnet_ids" {}
variable "private_subnet_ids" {}
variable "vpc_id" {}
variable "eks_security_group_name" {
  default = "eks-security-group-name"
}
variable "eks_version" {
  default = "1.14"
}

variable "default_node_group_desired_size" {
  type    = number
  default = 1
}

variable "default_node_group_max_size" {
  type    = number
  default = 1
}

variable "default_node_group_min_size" {
  type    = number
  default = 1
}

variable "default_node_group_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "eks_cluster_public_access_cidrs" {
  type    = list
  default = ["0.0.0.0/0"]
}
