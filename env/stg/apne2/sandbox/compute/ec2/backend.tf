# env/stg/apne2/sandbox/compute/ec2/backend.tf

terraform {
  backend "s3" {
    bucket       = "sandbox-terraform-tfstate-stg"                   # s3 버킷명
    key          = "stg/apne2/sandbox/compute/ec2/terraform.tfstate" # state 파일 s3 저장 경로
    region       = "ap-northeast-2"                                  # s3 리전
    use_lockfile = true                                              # S3 Native Locking 활성화
  }
}
