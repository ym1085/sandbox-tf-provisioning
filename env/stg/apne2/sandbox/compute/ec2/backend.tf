# env/stg/apne2/sandbox/05-compute/ec2/backend.tf

terraform {
  backend "s3" {
    bucket       = "sandbox-terraform-tfstate-stg"
    key          = "stg/apne2/sandbox/05-compute/ec2/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
