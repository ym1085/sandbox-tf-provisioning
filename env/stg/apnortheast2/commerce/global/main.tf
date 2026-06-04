# env/stg/apnortheast2/commerce/global/main.tf

module "iam" {
  source = "../../../../../modules/aws/iam"

  iam_custom_role       = var.iam_custom_role
  iam_custom_policy     = var.iam_custom_policy
  iam_managed_policy    = var.iam_managed_policy
  iam_policy_attachment = var.iam_policy_attachment
  iam_instance_profile  = var.iam_instance_profile

  tags = var.tags
}

module "route53" {
  source = "../../../../../modules/aws/route53"

  route53_zone_settings = var.route53_zone_settings

  project_name = var.project_name
  env          = var.env
  tags         = var.tags
}

module "acm" {
  source = "../../../../../modules/aws/acm"

  acm_certificate = var.acm_certificate
  route_zone_ids  = module.route53.route53_zone_id

  project_name = var.project_name
  env          = var.env
  tags         = var.tags
}
