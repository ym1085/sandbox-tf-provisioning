<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_acm_certificate.create_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate.import_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_route53_record.acm_validation_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_acm_certificate"></a> [acm\_certificate](#input\_acm\_certificate) | ACM 인증서 설정 | <pre>map(object({<br/>    mode                      = string<br/>    domain_name               = string # ACM 인증서를 발급할 도메인명<br/>    subject_alternative_names = string # 추가로 인증서에 포함시킬 도메인 목록<br/>    dns_validate              = bool<br/>    certificate_body          = optional(string)<br/>    private_key               = optional(string)<br/>    certificate_chain         = optional(string)<br/>    env                       = string # 환경 변수<br/>  }))</pre> | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | AWS 개발 환경 설정 | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | 프로젝트 이름 설정 | `string` | n/a | yes |
| <a name="input_route_zone_ids"></a> [route\_zone\_ids](#input\_route\_zone\_ids) | Route53 Zone ID 맵 (key -> zone\_id) | `map(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | 공통 태그 설정 | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_acm_certificate_arns"></a> [acm\_certificate\_arns](#output\_acm\_certificate\_arns) | ACM 인증서 ARN 목록 반환 |
<!-- END_TF_DOCS -->
