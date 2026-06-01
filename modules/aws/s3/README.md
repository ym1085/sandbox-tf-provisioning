<!-- BEGIN_TF_DOCS -->
## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Resources

The following resources are used by this module:

- [aws_s3_bucket.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) (resource)
- [aws_s3_bucket_public_access_block.public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) (resource)
- [aws_s3_bucket_server_side_encryption_configuration.server_side_encrypt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) (resource)
- [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_env"></a> [env](#input\_env)

Description: AWS 개발 환경 설정

Type: `string`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: 프로젝트 이름 설정

Type: `string`

### <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket)

Description: 생성하고자 하는 S3 버킷 정보 기재

Type:

```hcl
map(object({
    bucket_name = string
    bucket_versioning = object({
      versioning_configuration = object({
        status = string
      })
    })
    server_side_encryption = object({
      rule = object({
        apply_server_side_encryption_by_default = object({
          sse_algorithm = string
        })
      })
    })
    public_access_block = object({
      block_public_acls       = bool
      block_public_policy     = bool
      ignore_public_acls      = bool
      restrict_public_buckets = bool
    })
    env = string
  }))
```

### <a name="input_tags"></a> [tags](#input\_tags)

Description: 공통 태그 설정

Type: `map(string)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region)

Description: AWS 리전 설정

Type: `string`

Default: `"ap-northeast-2"`

## Outputs

The following outputs are exported:

### <a name="output_s3_bucket_names"></a> [s3\_bucket\_names](#output\_s3\_bucket\_names)

Description: 생성된 S3 버킷명 목록
<!-- END_TF_DOCS -->
