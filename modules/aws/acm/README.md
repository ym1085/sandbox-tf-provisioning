<!-- BEGIN_TF_DOCS -->
## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Resources

The following resources are used by this module:

- [aws_acm_certificate.create_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) (resource)
- [aws_acm_certificate.import_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) (resource)
- [aws_route53_record.acm_validation_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_acm_certificate"></a> [acm\_certificate](#input\_acm\_certificate)

Description: ACM 인증서 설정

Type:

```hcl
map(object({
    mode                      = string
    domain_name               = string # ACM 인증서를 발급할 도메인명
    subject_alternative_names = string # 추가로 인증서에 포함시킬 도메인 목록
    dns_validate              = bool
    certificate_body          = optional(string)
    private_key               = optional(string)
    certificate_chain         = optional(string)
    env                       = string # 환경 변수
  }))
```

### <a name="input_env"></a> [env](#input\_env)

Description: AWS 개발 환경 설정

Type: `string`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: 프로젝트 이름 설정

Type: `string`

### <a name="input_route_zone_ids"></a> [route\_zone\_ids](#input\_route\_zone\_ids)

Description: Route53 Zone ID 맵 (key -> zone\_id)

Type: `map(string)`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: 공통 태그 설정

Type: `map(string)`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_acm_certificate_arns"></a> [acm\_certificate\_arns](#output\_acm\_certificate\_arns)

Description: ACM 인증서 ARN 목록 반환
<!-- END_TF_DOCS -->
