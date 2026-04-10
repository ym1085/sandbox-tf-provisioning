# env/stg/apne2/sandbox/04-elb/backend.tf

terraform {
  backend "s3" {
    bucket       = "sandbox-terraform-tfstate-stg"
    key          = "stg/apne2/sandbox/04-elb/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
