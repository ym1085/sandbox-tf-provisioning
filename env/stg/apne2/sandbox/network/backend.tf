# env/stg/apne2/sandbox/02-network/backend.tf

terraform {
  backend "s3" {
    bucket       = "sandbox-terraform-tfstate-stg"
    key          = "stg/apne2/sandbox/02-network/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
