# env/stg/apne2/sandbox/ecr/main.tf

module "ecr" {
  source = "../../../../../modules/aws/ecr"

  # ECR 관련 설정
  ecr_repository = var.ecr_repository

  # 프로젝트 기본 설정
  tags = var.tags
}
