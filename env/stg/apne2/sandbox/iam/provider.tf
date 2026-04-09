# env/stg/apne2/sandbox/iam/backend.tf

provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  required_version = ">= 1.11.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}
