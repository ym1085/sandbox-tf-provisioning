# env/stg/apne2/sandbox/01-global/backend.tf

terraform {
  backend "s3" {
    bucket       = "sandbox-terraform-tfstate-stg"
    key          = "stg/apne2/sandbox/01-global/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
