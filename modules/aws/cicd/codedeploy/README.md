<!-- BEGIN_TF_DOCS -->
## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Resources

The following resources are used by this module:

- [aws_codedeploy_app.codedeploy_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) (resource)
- [aws_codedeploy_deployment_config.codedeploy_deployment_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config) (resource)
- [aws_codedeploy_deployment_group.codedeploy_deployment_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_alb_listener_arn"></a> [alb\_listener\_arn](#input\_alb\_listener\_arn)

Description: ALB Listener 이름 -> ARN Map 매핑

Type: `map(string)`

### <a name="input_codedeploy_app"></a> [codedeploy\_app](#input\_codedeploy\_app)

Description: CodeDeploy Application 생성

Type:

```hcl
map(object({
    compute_platform = string
    name             = string
    env              = string
  }))
```

### <a name="input_codedeploy_deployment_config"></a> [codedeploy\_deployment\_config](#input\_codedeploy\_deployment\_config)

Description: CodeDeploy 배포 구성 생성

Type:

```hcl
map(object({
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
```

### <a name="input_codedeploy_deployment_group"></a> [codedeploy\_deployment\_group](#input\_codedeploy\_deployment\_group)

Description: CodeDeploy Deployment Group 생성

Type:

```hcl
map(object({
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
```

### <a name="input_env"></a> [env](#input\_env)

Description: AWS 개발 환경 설정

Type: `string`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: 프로젝트 이름 설정

Type: `string`

### <a name="input_service_role_arn"></a> [service\_role\_arn](#input\_service\_role\_arn)

Description: CodeDeploy Service Role ARN

Type: `string`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: 공통 태그 설정

Type: `map(string)`

## Optional Inputs

No optional inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->