# env/stg/apne2/commerce/storage/backend.tf

terraform {
  backend "s3" {
    bucket       = "commerce-terraform-tfstate-stg"
    key          = "stg/apne2/commerce/storage/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
