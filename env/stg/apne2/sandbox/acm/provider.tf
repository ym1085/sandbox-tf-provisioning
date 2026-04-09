# env/stg/apne2/sandbox/acm/provider.tf

provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  required_version = ">= 1.11.4" # terraform 최소 요구 버전 설정

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Hashicorp에서 제공하는 공식 'AWS 프로바이더 설정'
      version = ">= 4.0.0"      # AWS 프로바이더의 버전 요구사항 지정(4.0 이상, 5.0 미만 (4.x.x))
    }
    random = {
      source  = "hashicorp/random" # Hashicorp에서 제공하는 랜덤 값 생성용 프로바이더
      version = ">= 3.5.1"
    }
  }
}
