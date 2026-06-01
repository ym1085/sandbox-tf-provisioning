# [network 스택] state 참조
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.terraform_state_bucket_name}-${var.env}"
    key    = "${var.env}/${var.aws_region_short}/${var.project_name}/network/terraform.tfstate"
    region = var.aws_region
  }
}
