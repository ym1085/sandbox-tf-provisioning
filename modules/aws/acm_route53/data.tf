# Route53 Zone 조회
data "aws_route53_zone" "import_route53_zone" {
  for_each = {
    for key, value in var.route53_zone_settings : key => value
    if value.mode == "import"
  }
  name         = each.value.name
  private_zone = false
}