# env/stg/apne2/commerce/ecr/backend.tf

terraform {
  backend "s3" {
    bucket       = "commerce-terraform-tfstate-stg"
    key          = "stg/apne2/commerce/ecr/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
