# Route53 Hosted Zone 신규 생성
# mode == "create" 인 항목만 대상으로 Public Hosted Zone을 생성
# 생성된 Hosted Zone ID는 ACM DNS 검증 레코드 생성 시 zone_id로 참조 가능
resource "aws_route53_zone" "create_route53_zone" {
  for_each = {
    for key, value in var.route53_zone_settings : key => value
    if value.mode == "create"
  }
  name = each.value.name

  tags = merge(var.tags, {
    Name = each.key
  })
}
