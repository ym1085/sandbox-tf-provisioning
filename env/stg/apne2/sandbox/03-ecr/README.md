<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.11.4 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.0.0  |

## Providers

No providers.

## Modules

| Name                                         | Source                         | Version |
| -------------------------------------------- | ------------------------------ | ------- |
| <a name="module_ecr"></a> [ecr](#module_ecr) | ../../../../../modules/aws/ecr | n/a     |

## Resources

No resources.

## Inputs

| Name                                                                        | Description                       | Type                                                                                                                                                                                  | Default | Required |
| --------------------------------------------------------------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_ecr_repository"></a> [ecr_repository](#input_ecr_repository) | ECR Private Image Repository 설정 | <pre>map(object({<br/> ecr_repository_name = string<br/> ecr_image_tag_mutability = string<br/> ecr_scan_on_push = bool<br/> ecr_force_delete = bool<br/> env = string<br/> }))</pre> | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                               | 공통 태그 설정                    | `map(string)`                                                                                                                                                                         | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
