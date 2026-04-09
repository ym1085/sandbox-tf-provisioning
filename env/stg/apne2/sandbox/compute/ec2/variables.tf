########################################
# 프로젝트 기본 설정
########################################
variable "project_name" {
  description = "프로젝트 이름 설정"
  type        = string
  default     = "terraform-ecs"
}

variable "aws_region" {
  description = "AWS 리전 설정"
  type        = string
  default     = "ap-northeast-2"
  validation {
    condition     = contains(["ap-northeast-2"], var.aws_region)
    error_message = "지원되지 않는 AWS 리전입니다."
  }
}

variable "availability_zones" {
  description = "가용 영역 설정"
  type        = list(string)
}
variable "aws_account" {
  description = "AWS 계정 ID 설정"
  type        = string
}

variable "env" {
  description = "AWS 개발 환경 설정"
  type        = string
}

########################################
# 네트워크 설정
########################################
variable "vpc_id" {
  description = "VPC ID 설정"
  type        = string
}

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

variable "public_subnet_ids" {
  description = "퍼블릭 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "프라이빗 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])"
  type        = list(string)
}

# DNS Hostname 사용 옵션, 기본 false(VPC 내 리소스가 AWS DNS 주소 사용 가능)
variable "enable_dns_support" {
  description = "AWS DNS 사용 가능 여부 지정"
  type        = bool
}

# DNS hostname을 만들건지 안 만들건지 지정하는 옵션
# 결국 enable_dns_support, enable_dns_hostnames 옵션 2개다 켜야 DNS 통신 가능할 듯
variable "enable_dns_hostnames" {
  description = "DNS hostname 사용 가능 여부 지정"
  type        = bool
}

variable "vpc_endpoint_gateway" {
  description = "VPC Endpoint Gateway 설정"
  type = map(object({
    endpoint_name     = string
    service_name      = string
    vpc_endpoint_type = string
  }))
}

variable "vpc_endpoint_interface" {
  description = "VPC Endpoint Interface 설정"
  type = map(object({
    endpoint_name       = string
    security_group_name = list(string)
    service_name        = string
    vpc_endpoint_type   = string
    private_dns_enabled = bool
  }))
}

########################################
# 로드밸런서 설정
########################################
variable "alb" {
  description = "ALB 설정"
  type = map(object({
    name                             = string
    internal                         = bool
    load_balancer_type               = string
    enable_deletion_protection       = bool
    enable_cross_zone_load_balancing = bool
    idle_timeout                     = number
    security_group_name              = string
    env                              = string
  }))
}

variable "alb_security_group" {
  description = "ALB 보안그룹 이름"
  type = map(object({
    security_group_name = string
    description         = string
    env                 = string
  }))
}

variable "alb_sg_rules" {
  description = "ALB 보안그룹 규칙"
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
  default = {}
}

variable "alb_listener" {
  description = "ALB Listener 설정"
  type = map(object({
    name              = string
    port              = number
    protocol          = string
    load_balancer_arn = string
    default_action = object({
      type             = string           # ALB Listener Rule 지정 -> forward, redirect,fixed-response
      target_group_arn = optional(string) # target group forward 하는 경우 사용
      fixed_response = optional(object({  # 고정 값을 응답해야 하는 경우 사용
        content_type = optional(string)
        message_body = optional(string)
        status_code  = optional(string)
      }))
    })
    env = string
  }))
}

variable "alb_listener_rule" {
  description = "ALB Listener rule 설정"
  type = map(object({
    type              = string
    path              = list(string)
    alb_listener_name = string
    target_group_name = string
    priority          = number
  }))
}

variable "target_group" {
  description = "ALB Target Group 설정"
  type = map(object({
    name        = string
    port        = number
    elb_type    = string
    protocol    = string
    target_type = string
    env         = string
    health_check = object({
      path                = string
      enabled             = bool
      healthy_threshold   = number
      interval            = number
      port                = number
      protocol            = string
      timeout             = number
      unhealthy_threshold = number
      internal            = bool
    })
  }))
}

########################################
# ECR 설정
########################################
variable "ecr_repository" {
  description = "ECR Private Image Repository 설정"
  type = map(object({
    ecr_repository_name      = string
    ecr_image_tag_mutability = string
    ecr_scan_on_push         = bool
    ecr_force_delete         = bool
    env                      = string
  }))
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
# ECS 클러스터 설정
########################################
variable "ecs_cluster" {
  description = "ECS Cluster 설정"
  type = map(object({
    cluster_name = string
    env          = string
  }))
}

variable "ecs_security_group" {
  description = "ECS 보안그룹 설정"
  type = map(object({
    security_group_name = string
    description         = string
    env                 = string
  }))
}

variable "ecs_sg_rules" {
  description = "ECS 보안그룹 규칙"
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

variable "ecs_task_definitions" {
  description = "ECS Task Definition 설정"
  type = map(object({
    name                                    = string
    task_role                               = string
    task_exec_role                          = string
    network_mode                            = string
    launch_type                             = string
    task_total_cpu                          = string
    task_total_memory                       = string
    runtime_platform_oprating_system_family = string
    runtime_platform_cpu_architecture       = string
    task_family                             = string
    env                                     = string
    volume = object({
      name = string
    })
    ephemeral_storage = number
    containers = list(object({
      name          = string
      image         = string
      version       = string
      cpu           = number
      memory        = number
      port          = number
      protocol      = string
      essential     = bool
      env_variables = map(string)
      mount_points = list(object({
        sourceVolume  = string
        containerPath = string
        readOnly      = bool
      }))
      health_check = object({
        command  = string
        interval = number
        timeout  = number
        retries  = number
      })
      env = string
    }))
  }))
}

variable "ecs_service" {
  description = "ECS 서비스 설정"
  type = map(object({
    subnets                       = string
    launch_type                   = string # ECS Launch Type ( EC2 or Fargate )
    service_role                  = string # ECS Service Role
    deployment_controller         = string
    cluster_name                  = string
    service_name                  = string # ECS 서비스 도메인명
    desired_count                 = number # ECS 서비스 Task 개수
    container_name                = string # ECS Container Name
    container_port                = number # ALB Listen Container Port
    task_definitions              = string
    env                           = string
    health_check_grace_period_sec = number # 헬스 체크 그레이스 기간
    assign_public_ip              = bool   # 퍼블릭 IP 지정 여부
    target_group_arn              = string
    security_group_name           = string
    deployment_circuit_breaker    = bool
  }))
}

variable "ecs_appautoscaling_target" {
  description = "ECS Auto Scaling Target 설정"
  type = map(object({
    min_capacity       = number # 최소 Task 2개가 항상 실행되도록 설정
    max_capacity       = number # 최대 Task 6개까지 증가 할 수 있도록 설정
    resource_id        = string # AG를 적용할 대상 리소스 지정, 여기서는 ECS 서비스 ARN 형식의 일부 기재
    scalable_dimension = string # 조정할 수 있는 AWS 리소스의 특정 속성을 지정하는 필드
    service_namespace  = string
    cluster_name       = string # AG가 어떤 ecs cluster에 매핑되는지 ecs cluster의 이름 지정
    service_name       = string # AG가 어떤 ecs service에 매핑되는지 ecs service의 이름 지정
  }))
}

variable "ecs_appautoscaling_target_policy" {
  description = "ECS Auto Scaling Target Policy 설정"
  type = map(object({
    scale_out = object({
      name        = string
      policy_type = string
      step_scaling_policy_conf = object({
        adjustment_type         = string
        cooldown                = number
        metric_aggregation_type = string
        step_adjustment = map(object({
          metric_interval_lower_bound = number
          metric_interval_upper_bound = optional(number)
          scaling_adjustment          = number
        }))
      })
    })
  }))
}

variable "ecs_cpu_scale_out_alert" {
  description = "ECS CPU Scale Out Alert Policy"
  type = map(object({
    alarm_name          = string
    comparison_operator = string
    evaluation_periods  = string
    metric_name         = string
    namespace           = string
    period              = string
    statistic           = string
    threshold           = string
    dimensions = object({
      cluster_name = string
      service_name = string
    })
    env = string
  }))
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
# CI/CD 설정
########################################
# variable "codedeploy_app" {
#   description = "CodeDeploy Application 생성"
#   type = map(object({
#     compute_platform = string
#     name             = string
#     env              = string
#   }))
# }

# variable "codedeploy_deployment_group" {
#   description = "CodeDeploy Deployment Group 생성"
#   type = map(object({
#     app_name               = string
#     deployment_group_name  = string
#     deployment_config_name = string

#     auto_rollback_configuration = object({
#       enabled = bool
#       events  = string
#     })

#     blue_green_deployment_config = object({
#       deployment_ready_option = object({
#         action_on_timeout    = string
#         wait_time_in_minutes = number
#       })
#       terminate_blue_instances_on_deployment_success = object({
#         action                           = string
#         termination_wait_time_in_minutes = number
#       })
#     })

#     deployment_style = object({
#       deployment_type   = string
#       deployment_option = string
#     })

#     ecs_service = object({
#       cluster_name = string
#       service_name = string
#     })

#     load_balancer_info = object({
#       target_group_pair_info = object({
#         prod_traffic_route = object({
#           listener_arns = string
#         })
#         test_traffic_route = object({
#           listener_arns = string
#         })
#         target_group = list(object({
#           name = string
#         }))
#       })
#     })
#     env = string
#   }))
# }

# variable "codedeploy_deployment_config" {
#   description = "CodeDeploy 배포 구성 생성"
#   type = map(object({
#     deployment_config_name = string
#     compute_platform       = string
#     traffic_routing_config = object({
#       type = string
#       time_based_canary = object({
#         interval   = number
#         percentage = number
#       })
#     })
#   }))
# }

########################################
# ACM 설정
########################################
variable "acm_certificate" {
  description = "ACM 인증서 설정"
  type = map(object({
    mode                      = string
    domain_name               = string # ACM 인증서를 발급할 도메인명
    subject_alternative_names = string # 추가로 인증서에 포함시킬 도메인 목록
    dns_validate              = bool
    certificate_body          = optional(string)
    private_key               = optional(string)
    certificate_chain         = optional(string)
    env                       = string # 환경 변수
  }))
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
