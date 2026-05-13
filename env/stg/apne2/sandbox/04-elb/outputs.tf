output "alb_arns" {
  description = "ELB 모듈에서 생성한 ALB ARN 목록"
  value       = module.elb.alb_arns
}

output "alb_dns_names" {
  description = "ELB 모듈에서 생성한 ALB DNS 이름 목록"
  value       = module.elb.alb_dns_names
}

output "alb_target_group_arn" {
  description = "ELB 모듈에서 생성한 Target Group ARN 목록"
  value       = module.elb.alb_target_group_arn
}

output "alb_listener_arn" {
  description = "ELB 모듈에서 생성한 Listener ARN 목록"
  value       = module.elb.alb_listener_arn
}

output "alb_security_group_id" {
  description = "ELB 모듈에서 생성한 ALB Security Group ID 목록"
  value       = module.elb.alb_security_group_id
}
