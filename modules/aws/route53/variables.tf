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

########################################
# Route 53 설정
########################################
variable "route53_zone_settings" {
  description = "Route53 Zone 설정"
  type = map(object({
    mode = string
    name = string
  }))
}

########################################
# 공통 태그 설정
########################################
variable "tags" {
  description = "공통 태그 설정"
  type        = map(string)
}
