# ECR 설정
resource "aws_ecr_repository" "ecr_repository" {
  for_each = var.ecr_repository

  name                 = "${each.value.ecr_repository_name}-${each.value.env}"
  image_tag_mutability = each.value.ecr_image_tag_mutability
  force_delete         = each.value.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = each.value.ecr_scan_on_push
  }

  tags = merge(var.tags, {
    Name = "${each.value.ecr_repository_name}-${each.value.env}"
  })
}
