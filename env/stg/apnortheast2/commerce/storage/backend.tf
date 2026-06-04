# env/stg/apnortheast2/commerce/storage/backend.tf

terraform {
  backend "s3" {
    bucket       = "commerce-terraform-tfstate-apnortheast2-stg"
    key          = "stg/apnortheast2/commerce/storage/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
    encrypt      = true
  }
}
