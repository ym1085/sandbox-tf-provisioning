########################################
# 프로젝트 기본 설정
########################################
variable "project_name" {
  description = "프로젝트 이름 설정(예: commerce)"
  type        = string
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

variable "env" {
  description = "AWS 개발 환경 설정"
  type        = string
}

variable "terraform_state_bucket_name" {
  description = "Terraform remote state가 저장된 S3 버킷 이름 (예: domain-terraform-tfstate-stg)"
  type        = string
}

########################################
# CI/CD 설정
########################################
variable "codedeploy_app" {
  description = "CodeDeploy Application 생성"
  type = map(object({
    compute_platform = string
    name             = string
    env              = string
  }))
}

variable "codedeploy_deployment_group" {
  description = "CodeDeploy Deployment Group 생성"
  type = map(object({
    app_name               = string
    deployment_group_name  = string
    deployment_config_name = string

    auto_rollback_configuration = object({
      enabled = bool
      events  = string
    })

    blue_green_deployment_config = object({
      deployment_ready_option = object({
        action_on_timeout    = string
        wait_time_in_minutes = number
      })
      terminate_blue_instances_on_deployment_success = object({
        action                           = string
        termination_wait_time_in_minutes = number
      })
    })

    deployment_style = object({
      deployment_type   = string
      deployment_option = string
    })

    ecs_service = object({
      cluster_name = string
      service_name = string
    })

    load_balancer_info = object({
      target_group_pair_info = object({
        prod_traffic_route = object({
          listener_arns = string
        })
        test_traffic_route = object({
          listener_arns = string
        })
        target_group = list(object({
          name = string
        }))
      })
    })
    env = string
  }))
}

variable "codedeploy_deployment_config" {
  description = "CodeDeploy 배포 구성 생성"
  type = map(object({
    deployment_config_name = string
    compute_platform       = string
    traffic_routing_config = object({
      type = string
      time_based_canary = object({
        interval   = number
        percentage = number
      })
    })
  }))
}

########################################
# 공통 태그 설정
########################################
variable "tags" {
  description = "공통 태그 설정"
  type        = map(string)
}
