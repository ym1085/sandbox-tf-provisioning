# modules/aws/acm/outputs.tf

output "acm_certificate_arns" {
  description = "ACM 인증서 ARN 목록 반환"
  value = merge(
    { for k, v in aws_acm_certificate.create_cert : k => v.arn },
    { for k, v in aws_acm_certificate.import_cert : k => v.arn }
  )
}
