########################################
# 프로젝트 기본 설정
########################################
variable "availability_zones" {
  description = "가용 영역 설정"
  type        = list(string)
}

variable "env" {
  description = "AWS 개발 환경 설정"
  type        = string
}

########################################
# EC2 설정
########################################
variable "ec2_instance" {
  description = "EC2 생성 정보 입력"
  type = map(object({
    create_yn                   = string
    ami_type                    = string # 기존 AMI or 신규 생성 EC2 여부 지정
    instance_type               = string
    subnet_type                 = string
    availability_zones          = string
    associate_public_ip_address = bool
    disable_api_termination     = bool
    instance_name               = string
    security_group_name         = string
    env                         = string
    script_file_name            = optional(string)
    iam_instance_profile        = optional(string)
    key_pair_name               = string
    private_ip                  = optional(string)

    root_block_device = object({
      volume_type           = optional(string)
      volume_size           = optional(number)
      delete_on_termination = optional(bool)
      encrypted             = optional(bool)
    })

    owners = string
    filter = list(object({
      name   = optional(string)
      values = optional(list(string))
    }))
  }))
}

variable "ec2_security_group" {
  description = "EC2 보안그룹 생성"
  type = map(object({
    security_group_name = optional(string)
    description         = optional(string)
    env                 = optional(string)
  }))
}

variable "ec2_sg_rules" {
  description = "EC2 보안그룹 규칙"
  type = map(object({
    type                         = string
    description                  = string
    security_group_key           = string
    from_port                    = number
    to_port                      = number
    ip_protocol                  = string
    cidr_ipv4                    = optional(list(string))
    referenced_security_group_id = optional(list(string))
  }))
}

variable "ec2_key_pair" {
  description = "EC2 key pair"
  type = map(object({
    name = string
    env  = string
  }))
}

########################################
# 공통 태그 설정
########################################
variable "tags" {
  description = "공통 태그 설정"
  type        = map(string)
}
