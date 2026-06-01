# [global 스택] IAM state 참조
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "${var.terraform_state_bucket_name}-${var.env}"
    key    = "${var.env}/${var.aws_region_short}/${var.project_name}/global/terraform.tfstate"
    region = var.aws_region
  }
}

# [elb 스택] state 참조
data "terraform_remote_state" "elb" {
  backend = "s3"
  config = {
    bucket = "${var.terraform_state_bucket_name}-${var.env}"
    key    = "${var.env}/${var.aws_region_short}/${var.project_name}/elb/terraform.tfstate"
    region = var.aws_region
  }
}
