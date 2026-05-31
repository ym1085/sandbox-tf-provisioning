# env/stg/apne2/commerce/global/backend.tf

terraform {
  backend "s3" {
    bucket       = "commerce-terraform-tfstate-stg"
    key          = "stg/apne2/commerce/global/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
