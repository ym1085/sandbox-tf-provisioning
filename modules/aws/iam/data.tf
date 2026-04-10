# IAM 관리형 정책 조회
data "aws_iam_policy" "managed_policy" {
  for_each = var.iam_managed_policy
  arn      = each.value.arn
}
