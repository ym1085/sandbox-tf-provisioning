<!-- BEGIN_TF_DOCS -->
## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Resources

The following resources are used by this module:

- [aws_instance.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) (resource)
- [aws_security_group.ec2_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (resource)
- [aws_vpc_security_group_egress_rule.ec2_sg_egress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) (resource)
- [aws_vpc_security_group_ingress_rule.ec2_sg_ingress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) (resource)
- [aws_ami.amazon_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) (data source)
- [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones)

Description: 가용 영역 설정

Type: `list(string)`

### <a name="input_ec2_instance"></a> [ec2\_instance](#input\_ec2\_instance)

Description: EC2 생성 정보 입력

Type:

```hcl
map(object({
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
```

### <a name="input_ec2_key_pair"></a> [ec2\_key\_pair](#input\_ec2\_key\_pair)

Description: EC2 key pair

Type:

```hcl
map(object({
    name = string
    env  = string
  }))
```

### <a name="input_ec2_security_group"></a> [ec2\_security\_group](#input\_ec2\_security\_group)

Description: EC2 보안그룹 설정

Type:

```hcl
map(object({
    security_group_name = string
    description         = string
    env                 = string
  }))
```

### <a name="input_ec2_sg_rules"></a> [ec2\_sg\_rules](#input\_ec2\_sg\_rules)

Description: EC2 보안그룹 규칙

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

### <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile)

Description: IAM instance profile

Type:

```hcl
map(object({
    name      = optional(string)
    role_name = optional(string)
  }))
```

### <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids)

Description: 프라이빗 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])

Type: `list(string)`

### <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids)

Description: 퍼블릭 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])

Type: `list(string)`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: 공통 태그 설정

Type: `map(string)`

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: VPC ID where the security groups will be created

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_env"></a> [env](#input\_env)

Description: Environment (e.g., dev, staging, prod)

Type: `string`

Default: `"stg"`

## Outputs

The following outputs are exported:

### <a name="output_ec2_security_group_id"></a> [ec2\_security\_group\_id](#output\_ec2\_security\_group\_id)

Description: EC2 보안그룹 ID 목록
<!-- END_TF_DOCS -->