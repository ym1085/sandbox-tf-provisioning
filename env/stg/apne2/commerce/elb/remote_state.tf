# network remote state 조회
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "commerce-terraform-tfstate-stg"
    key    = "stg/apne2/commerce/network/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
