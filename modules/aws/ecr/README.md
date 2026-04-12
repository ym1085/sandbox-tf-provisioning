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

| Name                                                                                                                            | Type     |
| ------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_ecr_repository.ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |

## Inputs

| Name                                                                        | Description    | Type                                                                                                                                                                                  | Default | Required |
| --------------------------------------------------------------------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_ecr_repository"></a> [ecr_repository](#input_ecr_repository) | ECR repository | <pre>map(object({<br/> ecr_repository_name = string<br/> ecr_image_tag_mutability = string<br/> ecr_scan_on_push = bool<br/> ecr_force_delete = bool<br/> env = string<br/> }))</pre> | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                               | 공통 태그 설정 | `map(string)`                                                                                                                                                                         | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
