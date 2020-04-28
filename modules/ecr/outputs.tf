output "cacheservice_url" {
  value = aws_ecr_repository.default[0].repository_url
}
output "ruby-pinger_url" {
  value = aws_ecr_repository.default[1].repository_url
}
output "jaeger-rd-web" {
  value = aws_ecr_repository.default[2].repository_url
}
output "jaeger-rd-dataservice" {
  value = aws_ecr_repository.default[3].repository_url
}
output "jaeger-rd-logservice" {
  value = aws_ecr_repository.default[4].repository_url
}
output "jaeger-rd-loadbalancer" {
  value = aws_ecr_repository.default[5].repository_url
}