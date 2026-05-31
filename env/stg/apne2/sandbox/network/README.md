<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.11.4 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.0.0  |

## Providers

No providers.

## Modules

| Name                                                     | Source                             | Version |
| -------------------------------------------------------- | ---------------------------------- | ------- |
| <a name="module_network"></a> [network](#module_network) | ../../../../../modules/aws/network | n/a     |

## Resources

No resources.

## Inputs

| Name                                                                                          | Description                      | Type           | Default            | Required |
| --------------------------------------------------------------------------------------------- | -------------------------------- | -------------- | ------------------ | :------: |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones)       | 가용 영역 설정                   | `list(string)` | n/a                |   yes    |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                               | AWS 리전 설정                    | `string`       | `"ap-northeast-2"` |    no    |
| <a name="input_enable_dns_hostnames"></a> [enable_dns_hostnames](#input_enable_dns_hostnames) | DNS hostname 사용 가능 여부 지정 | `bool`         | n/a                |   yes    |
| <a name="input_enable_dns_support"></a> [enable_dns_support](#input_enable_dns_support)       | AWS DNS 사용 가능 여부 지정      | `bool`         | n/a                |   yes    |
| <a name="input_env"></a> [env](#input_env)                                                    | AWS 개발 환경 설정               | `string`       | n/a                |   yes    |
| <a name="input_private_subnets_cidr"></a> [private_subnets_cidr](#input_private_subnets_cidr) | 프라이빗 서브넷 설정             | `list(string)` | n/a                |   yes    |
| <a name="input_project_name"></a> [project_name](#input_project_name)                         | 프로젝트 이름 설정               | `string`       | n/a                |   yes    |
| <a name="input_public_subnets_cidr"></a> [public_subnets_cidr](#input_public_subnets_cidr)    | 퍼블릭 서브넷 설정               | `list(string)` | n/a                |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                 | 공통 태그 설정                   | `map(string)`  | `{}`               |    no    |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input_vpc_cidr)                                     | VPC CIDR 설정                    | `string`       | n/a                |   yes    |

## Outputs

| Name                                                                                                  | Description               |
| ----------------------------------------------------------------------------------------------------- | ------------------------- |
| <a name="output_private_route_table_id"></a> [private_route_table_id](#output_private_route_table_id) | 프라이빗 라우트 테이블 ID |
| <a name="output_private_subnet_ids"></a> [private_subnet_ids](#output_private_subnet_ids)             | 프라이빗 서브넷 ID 목록   |
| <a name="output_public_route_table_id"></a> [public_route_table_id](#output_public_route_table_id)    | 퍼블릭 라우트 테이블 ID   |
| <a name="output_public_subnet_ids"></a> [public_subnet_ids](#output_public_subnet_ids)                | 퍼블릭 서브넷 ID 목록     |
| <a name="output_vpc_cidr_block"></a> [vpc_cidr_block](#output_vpc_cidr_block)                         | VPC CIDR 블록             |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id)                                                 | 생성된 VPC ID             |

<!-- END_TF_DOCS -->
