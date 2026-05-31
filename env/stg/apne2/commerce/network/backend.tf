# env/stg/apne2/commerce/network/backend.tf

terraform {
  backend "s3" {
    bucket       = "commerce-terraform-tfstate-stg"
    key          = "stg/apne2/commerce/network/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
