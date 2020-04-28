// Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = merge(
    {
      "Name" = format("%s", var.vpc_name),
    },
    var.vpc_additional_tags
  )
}
