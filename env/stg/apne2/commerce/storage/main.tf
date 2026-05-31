# env/stg/apne2/commerce/storage/main.tf

module "s3" {
  source = "../../../../../modules/aws/s3"

  s3_bucket = var.s3_bucket

  project_name = var.project_name
  env          = var.env
  tags         = var.tags
}
