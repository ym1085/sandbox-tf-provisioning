<!-- BEGIN_TF_DOCS -->
## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Resources

The following resources are used by this module:

- [aws_ecr_repository.ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_ecr_repository"></a> [ecr\_repository](#input\_ecr\_repository)

Description: ECR repository

Type:

```hcl
map(object({
    ecr_repository_name      = string
    ecr_image_tag_mutability = string
    ecr_scan_on_push         = bool
    ecr_force_delete         = bool
    env                      = string
  }))
```

### <a name="input_tags"></a> [tags](#input\_tags)

Description: 공통 태그 설정

Type: `map(string)`

## Optional Inputs

No optional inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->