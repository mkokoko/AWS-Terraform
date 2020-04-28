output "ecr_urls" {
  value = ["${module.ecr.*}"]
}

output "charts_bucket_name" {
  value = aws_s3_bucket.charts.id
}
