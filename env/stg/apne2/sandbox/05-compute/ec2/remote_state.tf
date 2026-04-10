# network remote state 조회
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "sandbox-terraform-tfstate-stg"
    key    = "stg/apne2/sandbox/02-network/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# iam remote state 조회
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "sandbox-terraform-tfstate-stg"
    key    = "stg/apne2/sandbox/01-global/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
