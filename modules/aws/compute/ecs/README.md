<!-- BEGIN_TF_DOCS -->
## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Resources

The following resources are used by this module:

- [aws_appautoscaling_policy.ecs_policy_scale_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) (resource)
- [aws_appautoscaling_target.ecs_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) (resource)
- [aws_cloudwatch_metric_alarm.ecs_cpu_scale_out_alert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) (resource)
- [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) (resource)
- [aws_ecs_service.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) (resource)
- [aws_ecs_task_definition.ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) (resource)
- [aws_security_group.ecs_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (resource)
- [aws_vpc_security_group_egress_rule.ecs_security_group_egress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) (resource)
- [aws_vpc_security_group_ingress_rule.ecs_security_group_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_alb_listener_arn"></a> [alb\_listener\_arn](#input\_alb\_listener\_arn)

Description: AWS ECS ALB LISTENER ARN

Type: `map(string)`

### <a name="input_alb_tg_arn"></a> [alb\_tg\_arn](#input\_alb\_tg\_arn)

Description: AWS ECS ALB TG ARN

Type: `map(string)`

### <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones)

Description: 가용 영역 설정

Type: `list(string)`

### <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account)

Description: AWS 계정 ID 설정

Type: `string`

### <a name="input_ecs_appautoscaling_target"></a> [ecs\_appautoscaling\_target](#input\_ecs\_appautoscaling\_target)

Description: ECS Auto Scaling Target 설정

Type:

```hcl
map(object({
    min_capacity       = number # 최소 Task 2개가 항상 실행되도록 설정
    max_capacity       = number # 최대 Task 6개까지 증가 할 수 있도록 설정
    resource_id        = string # AG를 적용할 대상 리소스 지정, 여기서는 ECS 서비스 ARN 형식의 일부 기재
    scalable_dimension = string # 조정할 수 있는 AWS 리소스의 특정 속성을 지정하는 필드
    service_namespace  = string
    cluster_name       = string # AG가 어떤 ecs cluster에 매핑되는지 ecs cluster의 이름 지정
    service_name       = string # AG가 어떤 ecs service에 매핑되는지 ecs service의 이름 지정
  }))
```

### <a name="input_ecs_appautoscaling_target_policy"></a> [ecs\_appautoscaling\_target\_policy](#input\_ecs\_appautoscaling\_target\_policy)

Description: ECS Auto Scaling Target Policy 설정

Type:

```hcl
map(object({
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
```

### <a name="input_ecs_cluster"></a> [ecs\_cluster](#input\_ecs\_cluster)

Description: ECS Cluster 설정

Type:

```hcl
map(object({
    cluster_name = string
    env          = string
  }))
```

### <a name="input_ecs_cpu_scale_out_alert"></a> [ecs\_cpu\_scale\_out\_alert](#input\_ecs\_cpu\_scale\_out\_alert)

Description: ECS CPU Scale Out Alert Policy

Type:

```hcl
map(object({
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
```

### <a name="input_ecs_security_group"></a> [ecs\_security\_group](#input\_ecs\_security\_group)

Description: ECS 보안그룹 설정

Type:

```hcl
map(object({
    security_group_name = string
    description         = string
    env                 = string
  }))
```

### <a name="input_ecs_service"></a> [ecs\_service](#input\_ecs\_service)

Description: ECS 서비스 설정

Type:

```hcl
map(object({
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
```

### <a name="input_ecs_sg_rules"></a> [ecs\_sg\_rules](#input\_ecs\_sg\_rules)

Description: ECS 보안그룹 규칙

Type:

```hcl
map(object({
    type                         = string
    description                  = string
    security_group_key           = string
    from_port                    = number
    to_port                      = number
    ip_protocol                  = string
    cidr_ipv4                    = optional(list(string))
    referenced_security_group_id = optional(list(string))
  }))
```

### <a name="input_ecs_task_definitions"></a> [ecs\_task\_definitions](#input\_ecs\_task\_definitions)

Description: ECS Task Definition 설정

Type:

```hcl
map(object({
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
```

### <a name="input_ecs_task_exec_role_arn"></a> [ecs\_task\_exec\_role\_arn](#input\_ecs\_task\_exec\_role\_arn)

Description: security module에서 생성된 role arn을 참조

Type: `string`

### <a name="input_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#input\_ecs\_task\_role\_arn)

Description: security module에서 생성된 role arn을 참조

Type: `string`

### <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids)

Description: 프라이빗 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])

Type: `list(string)`

### <a name="input_private_subnets_cidr"></a> [private\_subnets\_cidr](#input\_private\_subnets\_cidr)

Description: 프라이빗 서브넷 설정

Type: `list(string)`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: 프로젝트 이름 설정

Type: `string`

### <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids)

Description: 퍼블릭 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])

Type: `list(string)`

### <a name="input_public_subnets_cidr"></a> [public\_subnets\_cidr](#input\_public\_subnets\_cidr)

Description: 퍼블릭 서브넷 설정

Type: `list(string)`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: 공통 태그 설정

Type: `map(string)`

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: VPC ID 설정

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region)

Description: AWS 가용영역 설정

Type: `string`

Default: `"ap-northeast-2"`

### <a name="input_env"></a> [env](#input\_env)

Description: AWS 개발 환경 설정

Type: `string`

Default: `"stg"`

## Outputs

The following outputs are exported:

### <a name="output_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#output\_ecs\_cluster\_arn)

Description: ECS Cluster ARN 반환

### <a name="output_ecs_cluster_id"></a> [ecs\_cluster\_id](#output\_ecs\_cluster\_id)

Description: ECS Cluster ID 반환

### <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name)

Description: ECS Cluster Name 반환

### <a name="output_ecs_security_group_id"></a> [ecs\_security\_group\_id](#output\_ecs\_security\_group\_id)

Description: ECS Service 보안그룹 ID 반환

### <a name="output_ecs_service_id"></a> [ecs\_service\_id](#output\_ecs\_service\_id)

Description: ECS Service ID 반환

### <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name)

Description: ECS Service Name 반환
<!-- END_TF_DOCS -->