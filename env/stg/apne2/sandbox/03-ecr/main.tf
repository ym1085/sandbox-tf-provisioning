# env/stg/apne2/sandbox/ecr/main.tf

module "ecr" {
  source = "../../../../../modules/aws/ecr"

  ecr_repository = var.ecr_repository

  tags = var.tags
}
