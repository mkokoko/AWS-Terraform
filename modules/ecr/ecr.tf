resource "aws_ecr_repository" "default" {
  count = length(var.repository_name)
  name  = element(var.repository_name, count.index)
}

resource "aws_ecr_lifecycle_policy" "default" {
  count = length(var.repository_name)

  repository = aws_ecr_repository.default[count.index].name
  policy     = var.lifecycle_policy != "" ? var.lifecycle_policy : file("${path.module}/lifecycle-policy.json.tpl")
}
