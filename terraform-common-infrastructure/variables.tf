variable "project_name" {
  default = "helm-rnd"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "ecr_repositories" { //Put Repository names to create
  default = [ 
    "cacheservice",
    "ruby-pinger",
  ]
}
