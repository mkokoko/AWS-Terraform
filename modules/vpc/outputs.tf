output "out_vpc_id" {
  value = aws_vpc.vpc.id
}

output "out_vpc_name" {
  value = var.vpc_name
}
