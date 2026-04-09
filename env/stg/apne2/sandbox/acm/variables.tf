########################################
# 프로젝트 기본 설정
########################################
variable "project_name" {
  description = "프로젝트 이름 설정"
  type        = string
}

variable "env" {
  description = "AWS 개발 환경 설정"
  type        = string
}

variable "tags" {
  description = "공통 태그 설정"
  type        = map(string)
}

########################################
# ACM 및 Route53 설정
########################################
variable "acm_certificate" {
  description = "ACM 인증서 값"
  type = map(object({
    mode                      = string
    domain_name               = string
    subject_alternative_names = string
    dns_validate              = bool
    certificate_body          = optional(string)
    private_key               = optional(string)
    certificate_chain         = optional(string)
    env                       = string
  }))
}

variable "route53_zone_settings" {
  description = "Route53 관련 설정"
  type = map(object({
    mode = string
    name = string # 생성할 도메인 주소명
  }))
}
