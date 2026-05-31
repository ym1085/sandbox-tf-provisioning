# env/stg/apne2/commerce/compute/ec2/backend.tf

terraform {
  backend "s3" {
    bucket       = "commerce-terraform-tfstate-stg"
    key          = "stg/apne2/commerce/compute/ec2/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
