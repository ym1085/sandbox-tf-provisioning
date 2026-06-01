<!-- BEGIN_TF_DOCS -->
## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Resources

The following resources are used by this module:

- [aws_iam_instance_profile.ec2_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) (resource)
- [aws_iam_policy.custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_role.custom_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy_attachment.role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_policy.managed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_iam_custom_policy"></a> [iam\_custom\_policy](#input\_iam\_custom\_policy)

Description: IAM 사용자 생성 정책

Type:

```hcl
map(object({
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
```

### <a name="input_iam_custom_role"></a> [iam\_custom\_role](#input\_iam\_custom\_role)

Description: IAM Role 생성

Type:

```hcl
map(object({
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
```

### <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile)

Description: IAM instance profile

Type:

```hcl
map(object({
    name      = string
    role_name = string
  }))
```

### <a name="input_iam_managed_policy"></a> [iam\_managed\_policy](#input\_iam\_managed\_policy)

Description: IAM 관리형 정책

Type:

```hcl
map(object({
    name = string
    arn  = string
    env  = string
  }))
```

### <a name="input_iam_policy_attachment"></a> [iam\_policy\_attachment](#input\_iam\_policy\_attachment)

Description: IAM Policy를 Role에 연결

Type:

```hcl
map(object({
    role_name   = optional(string)
    policy_name = optional(string)
  }))
```

### <a name="input_tags"></a> [tags](#input\_tags)

Description: 공통 태그 설정

Type: `map(string)`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_iam_instance_profile"></a> [iam\_instance\_profile](#output\_iam\_instance\_profile)

Description: Map of IAM instance profiles

### <a name="output_iam_policy_arns"></a> [iam\_policy\_arns](#output\_iam\_policy\_arns)

Description: Map of IAM policy ARNs

### <a name="output_iam_policy_ids"></a> [iam\_policy\_ids](#output\_iam\_policy\_ids)

Description: Map of IAM policy IDs

### <a name="output_iam_policy_names"></a> [iam\_policy\_names](#output\_iam\_policy\_names)

Description: Map of IAM policy names

### <a name="output_iam_role_arns"></a> [iam\_role\_arns](#output\_iam\_role\_arns)

Description: Map of IAM role ARNs

### <a name="output_iam_role_ids"></a> [iam\_role\_ids](#output\_iam\_role\_ids)

Description: Map of IAM role IDs

### <a name="output_iam_role_names"></a> [iam\_role\_names](#output\_iam\_role\_names)

Description: Map of IAM role names
<!-- END_TF_DOCS -->
