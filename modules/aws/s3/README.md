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

| Name                                                                                                                                                                                                 | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_s3_bucket.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                                                            | resource |
| [aws_s3_bucket_public_access_block.public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)                                   | resource |
| [aws_s3_bucket_server_side_encryption_configuration.server_side_encrypt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning)                                                              | resource |

## Inputs

| Name                                                                  | Description                       | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | Default            | Required |
| --------------------------------------------------------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ | :------: |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)       | AWS 리전 설정                     | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `"ap-northeast-2"` |    no    |
| <a name="input_env"></a> [env](#input_env)                            | AWS 개발 환경 설정                | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | n/a                |   yes    |
| <a name="input_project_name"></a> [project_name](#input_project_name) | 프로젝트 이름 설정                | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `"sandbox"`        |    no    |
| <a name="input_s3_bucket"></a> [s3_bucket](#input_s3_bucket)          | 생성하고자 하는 S3 버킷 정보 기재 | <pre>map(object({<br/> bucket_name = string<br/> bucket_versioning = object({<br/> versioning_configuration = object({<br/> status = string<br/> })<br/> })<br/> server_side_encryption = object({<br/> rule = object({<br/> apply_server_side_encryption_by_default = object({<br/> sse_algorithm = string<br/> })<br/> })<br/> })<br/> public_access_block = object({<br/> block_public_acls = bool<br/> block_public_policy = bool<br/> ignore_public_acls = bool<br/> restrict_public_buckets = bool<br/> })<br/> env = string<br/> }))</pre> | n/a                |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                         | 공통 태그 설정                    | `map(string)`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | n/a                |   yes    |

## Outputs

| Name                                                                             | Description           |
| -------------------------------------------------------------------------------- | --------------------- |
| <a name="output_s3_bucket_names"></a> [s3_bucket_names](#output_s3_bucket_names) | 생성된 S3 버킷명 목록 |

<!-- END_TF_DOCS -->
