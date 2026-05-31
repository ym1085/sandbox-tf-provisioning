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
# IAM 설정
########################################
variable "iam_custom_role" {
  description = "IAM Role 생성"
  type = map(object({
    name        = optional(string)
    description = optional(string)
    version     = optional(string)
    statement = object({
      Sid    = optional(string)
      Action = string
      Effect = string
      Principal = object({
        Service = string
      })
    })
    env = string
  }))
}

variable "iam_custom_policy" {
  description = "IAM 사용자 생성 정책"
  type = map(object({
    name        = optional(string)
    description = optional(string)
    version     = optional(string)
    statement = optional(object({
      Sid      = optional(string)
      Action   = optional(list(string))
      Effect   = optional(string)
      Resource = optional(list(string))
    }))
    env = string
  }))
}

variable "iam_managed_policy" {
  description = "IAM 관리형 정책"
  type = map(object({
    name = string
    arn  = string
    env  = string
  }))
}

variable "iam_policy_attachment" {
  description = "IAM Policy를 Role에 연결"
  type = map(object({
    role_name   = optional(string)
    policy_name = optional(string)
  }))
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
  type = map(object({
    name      = optional(string)
    role_name = optional(string)
  }))
}

########################################
# S3 설정
########################################
variable "s3_bucket" {
  description = "생성하고자 하는 S3 버킷 정보 기재"
  type = map(object({
    bucket_name = string
    bucket_versioning = object({
      versioning_configuration = object({
        status = string
      })
    })
    server_side_encryption = object({
      rule = object({
        apply_server_side_encryption_by_default = object({
          sse_algorithm = string
        })
      })
    })
    public_access_block = object({
      block_public_acls       = bool
      block_public_policy     = bool
      ignore_public_acls      = bool
      restrict_public_buckets = bool
    })
    env = string
  }))
}

########################################
# ACM
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

########################################
# Route53
########################################
variable "route53_zone_settings" {
  description = "Route53 관련 설정"
  type = map(object({
    mode = string
    name = string # 생성할 도메인 주소명
  }))
}
