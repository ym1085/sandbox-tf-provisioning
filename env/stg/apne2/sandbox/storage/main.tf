# env/stg/apne2/sandbox/storage/main.tf

module "storage" {
  source = "../../../../../modules/aws/storage"

  s3_bucket = var.s3_bucket

  project_name = var.project_name
  env          = var.env
  tags         = var.tags
}
