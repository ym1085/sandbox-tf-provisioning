# ACM 인증서 신규 발급 (mode == "create")
# dns_validate = true 이면 DNS 방식, false 이면 EMAIL 방식으로 도메인 소유권 검증
# create_before_destroy: 인증서 교체 시 기존 인증서를 먼저 삭제하면 ALB가 잠깐 끊기므로, 새 인증서를 먼저 만든 뒤 교체
resource "aws_acm_certificate" "create_certificate" {
  for_each = {
    for key, value in var.acm_certificate : key => value
    if value.mode == "create"
  }

  domain_name               = each.value.domain_name
  subject_alternative_names = [each.value.subject_alternative_names]
  validation_method         = each.value.dns_validate ? "DNS" : "EMAIL"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${each.key}-${each.value.env}"
  })
}

# 외부 CA에서 발급받은 인증서 가져오기 (mode == "import")
# ACM이 발급하지 않은 인증서(사설 CA, Let's Encrypt 등)를 AWS에 등록할 때 사용
resource "aws_acm_certificate" "import_certificate" {
  for_each = {
    for key, value in var.acm_certificate : key => value
    if value.mode == "import"
  }

  domain_name       = each.value.domain_name
  certificate_body  = each.value.certificate_body
  private_key       = each.value.private_key
  certificate_chain = each.value.certificate_chain

  tags = merge(var.tags, {
    Name = "${each.key}-${each.value.env}"
  })
}

# ACM DNS 검증용 CNAME 레코드
# create_cert의 domain_validation_options를 locals에서 맵으로 변환 후 생성
resource "aws_route53_record" "acm_validation_record" {
  for_each = local.acm_validation_records

  name            = each.value.name
  type            = each.value.type
  ttl             = 300
  records         = [each.value.record]
  allow_overwrite = true
  zone_id         = var.route_zone_ids[each.value.zone]

  depends_on = [aws_acm_certificate.create_certificate]
}
