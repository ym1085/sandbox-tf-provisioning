<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                            | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_instance_profile.ec2_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile)           | resource    |
| [aws_iam_policy.custom_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                          | resource    |
| [aws_iam_role.custom_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                | resource    |
| [aws_iam_role_policy_attachment.role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_policy.managed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy)                                      | data source |

## Inputs

| Name                                                                                             | Description              | Type                                                                                                                                                                                                                                                                                                                                   | Default | Required |
| ------------------------------------------------------------------------------------------------ | ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_iam_custom_policy"></a> [iam_custom_policy](#input_iam_custom_policy)             | IAM 사용자 생성 정책     | <pre>map(object({<br/> name = optional(string)<br/> description = optional(string)<br/> version = optional(string)<br/> statement = optional(object({<br/> Sid = optional(string)<br/> Action = optional(list(string))<br/> Effect = optional(string)<br/> Resource = optional(list(string))<br/> }))<br/> env = string<br/> }))</pre> | n/a     |   yes    |
| <a name="input_iam_custom_role"></a> [iam_custom_role](#input_iam_custom_role)                   | IAM Role 생성            | <pre>map(object({<br/> name = optional(string)<br/> description = optional(string)<br/> version = optional(string)<br/> statement = object({<br/> Sid = optional(string)<br/> Action = string<br/> Effect = string<br/> Principal = object({<br/> Service = string<br/> })<br/> })<br/> env = string<br/> }))</pre>                    | n/a     |   yes    |
| <a name="input_iam_instance_profile"></a> [iam_instance_profile](#input_iam_instance_profile)    | IAM instance profile     | <pre>map(object({<br/> name = string<br/> role_name = string<br/> }))</pre>                                                                                                                                                                                                                                                            | n/a     |   yes    |
| <a name="input_iam_managed_policy"></a> [iam_managed_policy](#input_iam_managed_policy)          | IAM 관리형 정책          | <pre>map(object({<br/> name = string<br/> arn = string<br/> env = string<br/> }))</pre>                                                                                                                                                                                                                                                | n/a     |   yes    |
| <a name="input_iam_policy_attachment"></a> [iam_policy_attachment](#input_iam_policy_attachment) | IAM Policy를 Role에 연결 | <pre>map(object({<br/> role_name = optional(string)<br/> policy_name = optional(string)<br/> }))</pre>                                                                                                                                                                                                                                 | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                    | 공통 태그 설정           | `map(string)`                                                                                                                                                                                                                                                                                                                          | n/a     |   yes    |

## Outputs

| Name                                                                                            | Description                  |
| ----------------------------------------------------------------------------------------------- | ---------------------------- |
| <a name="output_iam_instance_profile"></a> [iam_instance_profile](#output_iam_instance_profile) | Map of IAM instance profiles |
| <a name="output_iam_policy_arns"></a> [iam_policy_arns](#output_iam_policy_arns)                | Map of IAM policy ARNs       |
| <a name="output_iam_policy_ids"></a> [iam_policy_ids](#output_iam_policy_ids)                   | Map of IAM policy IDs        |
| <a name="output_iam_policy_names"></a> [iam_policy_names](#output_iam_policy_names)             | Map of IAM policy names      |
| <a name="output_iam_role_arns"></a> [iam_role_arns](#output_iam_role_arns)                      | Map of IAM role ARNs         |
| <a name="output_iam_role_ids"></a> [iam_role_ids](#output_iam_role_ids)                         | Map of IAM role IDs          |
| <a name="output_iam_role_names"></a> [iam_role_names](#output_iam_role_names)                   | Map of IAM role names        |

<!-- END_TF_DOCS -->
