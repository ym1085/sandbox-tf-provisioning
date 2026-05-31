data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "commerce-terraform-tfstate-stg"
    key    = "stg/apne2/commerce/global/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "elb" {
  backend = "s3"
  config = {
    bucket = "commerce-terraform-tfstate-stg"
    key    = "stg/apne2/commerce/elb/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
