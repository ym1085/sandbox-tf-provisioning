# env/stg/apne2/sandbox/01-global/main.tf

# iam module
module "iam" {
  source = "../../../../../modules/aws/iam"

  iam_custom_role       = var.iam_custom_role
  iam_custom_policy     = var.iam_custom_policy
  iam_managed_policy    = var.iam_managed_policy
  iam_policy_attachment = var.iam_policy_attachment
  iam_instance_profile  = var.iam_instance_profile

  tags = var.tags
}

# s3 module
module "s3" {
  source = "../../../../../modules/aws/s3"

  s3_bucket = var.s3_bucket

  project_name = var.project_name
  env          = var.env
  tags         = var.tags
}

# acm module
module "acm" {
  source = "../../../../../modules/aws/acm_route53"

  acm_certificate       = var.acm_certificate
  route53_zone_settings = var.route53_zone_settings

  project_name = var.project_name
  env          = var.env
  tags         = var.tags
}
