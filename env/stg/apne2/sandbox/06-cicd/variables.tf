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
