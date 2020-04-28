output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}
output "rds_user" {
  value = aws_db_instance.rds.username
}
output "rds_password" {
  value = aws_db_instance.rds.password
}