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
# 네트워크 설정
########################################
variable "vpc_cidr" {
  description = "VPC CIDR 설정"
  type        = string
}

variable "public_subnets_cidr" {
  description = "퍼블릭 서브넷 설정"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "프라이빗 서브넷 설정"
  type        = list(string)
}

variable "availability_zones" {
  description = "가용 영역 설정"
  type        = list(string)
}

variable "enable_dns_support" {
  description = "AWS DNS 사용 가능 여부 지정"
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "DNS hostname 사용 가능 여부 지정"
  type        = bool
}

########################################
# 공통 태그 설정
########################################
variable "tags" {
  description = "공통 태그 설정"
  type        = map(string)
}
