# env/stg/apne2/sandbox/01-global/outputs.tf

# iam
output "iam_role_ids" {
  description = "Map of IAM role IDs"
  value       = module.iam.iam_role_ids
}

output "iam_role_names" {
  description = "Map of IAM role names"
  value       = module.iam.iam_role_names
}

output "iam_role_arns" {
  description = "Map of IAM role ARNs"
  value       = module.iam.iam_role_arns
}

output "iam_policy_ids" {
  description = "Map of IAM policy IDs"
  value       = module.iam.iam_policy_ids
}

output "iam_policy_names" {
  description = "Map of IAM policy names"
  value       = module.iam.iam_policy_names
}

output "iam_policy_arns" {
  description = "Map of IAM policy ARNs"
  value       = module.iam.iam_policy_arns
}

output "iam_instance_profile" {
  description = "Map of IAM instance profiles"
  value       = module.iam.iam_instance_profile
}

# acm
output "acm_certificate_arns" {
  description = "ACM 인증서 ARN 목록 반환"
  value       = module.acm.acm_certificate_arns
}
