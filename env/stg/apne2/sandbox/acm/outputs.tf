# env/stg/apne2/sandbox/acm/outputs.tf

output "acm_certificate_arns" {
  description = "ACM 인증서 ARN 목록 반환"
  value       = module.acm.acm_certificate_arns
}
