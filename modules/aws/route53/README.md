<!-- BEGIN_TF_DOCS -->
## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Resources

The following resources are used by this module:

- [aws_route53_zone.create_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) (resource)
- [aws_route53_zone.import_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_env"></a> [env](#input\_env)

Description: AWS 개발 환경 설정

Type: `string`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: 프로젝트 이름 설정

Type: `string`

### <a name="input_route53_zone_settings"></a> [route53\_zone\_settings](#input\_route53\_zone\_settings)

Description: Route53 Zone 설정

Type:

```hcl
map(object({
    mode = string
    name = string
  }))
```

### <a name="input_tags"></a> [tags](#input\_tags)

Description: 공통 태그 설정

Type: `map(string)`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_route53_zone_id"></a> [route53\_zone\_id](#output\_route53\_zone\_id)

Description: Route53 Zone ID 맵
<!-- END_TF_DOCS -->