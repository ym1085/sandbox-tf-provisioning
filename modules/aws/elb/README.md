<!-- BEGIN_TF_DOCS -->
## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Resources

The following resources are used by this module:

- [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) (resource)
- [aws_lb_listener.alb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) (resource)
- [aws_lb_listener_rule.alb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) (resource)
- [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) (resource)
- [aws_security_group.alb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (resource)
- [aws_vpc_security_group_egress_rule.alb_egress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) (resource)
- [aws_vpc_security_group_ingress_rule.alb_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_alb"></a> [alb](#input\_alb)

Description: Application Load Balancer 설정

Type:

```hcl
map(object({
    name                             = string
    internal                         = bool
    load_balancer_type               = string
    enable_deletion_protection       = bool
    enable_cross_zone_load_balancing = bool
    idle_timeout                     = number
    security_group_name              = string
    env                              = string
  }))
```

### <a name="input_alb_listener"></a> [alb\_listener](#input\_alb\_listener)

Description: ALB Listener 설정

Type:

```hcl
map(object({
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
```

### <a name="input_alb_listener_rule"></a> [alb\_listener\_rule](#input\_alb\_listener\_rule)

Description: ALB listener rule

Type:

```hcl
map(object({
    type              = string
    path              = list(string)
    alb_listener_name = string
    target_group_name = string
    priority          = number
  }))
```

### <a name="input_alb_security_group"></a> [alb\_security\_group](#input\_alb\_security\_group)

Description: ALB 보안그룹 이름

Type:

```hcl
map(object({
    security_group_name = string
    description         = string
    env                 = string
  }))
```

### <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones)

Description: 가용 영역 설정

Type: `list(string)`

### <a name="input_env"></a> [env](#input\_env)

Description: AWS 개발 환경 설정

Type: `string`

### <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids)

Description: 퍼블릭 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])

Type: `list(string)`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: 공통 태그 설정

Type: `map(string)`

### <a name="input_target_group"></a> [target\_group](#input\_target\_group)

Description: Target group configuration

Type:

```hcl
map(object({
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
```

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: VPC ID(이미 생성되어 있는 VPC ID를 data 통해 받아오거나, 아니면 생성된 VPC ID를 넣는다)

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_alb_sg_rules"></a> [alb\_sg\_rules](#input\_alb\_sg\_rules)

Description: ALB 보안그룹 규칙

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

Default: `{}`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: 프로젝트 이름 설정

Type: `string`

Default: `"commerce"`

## Outputs

The following outputs are exported:

### <a name="output_alb_arns"></a> [alb\_arns](#output\_alb\_arns)

Description: 생성된 N개의 ALB의 ARN 반환

### <a name="output_alb_dns_names"></a> [alb\_dns\_names](#output\_alb\_dns\_names)

Description: 생성된 N개의 ALB의 DNS 반환

### <a name="output_alb_listener_arn"></a> [alb\_listener\_arn](#output\_alb\_listener\_arn)

Description: 생성된 N개의 ALB의 listener ARN 반환

### <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id)

Description: ALB 보안그룹 ID

### <a name="output_alb_target_group_arn"></a> [alb\_target\_group\_arn](#output\_alb\_target\_group\_arn)

Description: 생성된 N개의 TG의 ARN 반환
<!-- END_TF_DOCS -->