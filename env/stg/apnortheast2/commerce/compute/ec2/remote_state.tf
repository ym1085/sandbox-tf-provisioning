# [network 스택] state 참조
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.terraform_state_bucket_name}-${var.env}"
    key    = "${var.env}/apnortheast2/${var.project_name}/network/terraform.tfstate"
    region = var.aws_region
  }
}

# [global 스택] IAM state 참조
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "${var.terraform_state_bucket_name}-${var.env}"
    key    = "${var.env}/apnortheast2/${var.project_name}/global/terraform.tfstate"
    region = var.aws_region
  }
}
