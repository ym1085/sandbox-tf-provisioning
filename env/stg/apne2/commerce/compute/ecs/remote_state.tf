# iam 모듈의 remote state 참조
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "sandbox-terraform-tfstate-stg"
    key    = "stg/apne2/sandbox/01-global/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# network 모듈의 remote state 참조
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "sandbox-terraform-tfstate-stg"
    key    = "stg/apne2/sandbox/02-network/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# elb 모듈의 remote state 참조
data "terraform_remote_state" "elb" {
  backend = "s3"
  config = {
    bucket = "sandbox-terraform-tfstate-stg"
    key    = "stg/apne2/sandbox/04-elb/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
