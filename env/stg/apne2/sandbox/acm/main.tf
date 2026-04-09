# env/stg/apne2/sandbox/acm/main.tf

# acm module
module "acm" {
  source = "../../../../../modules/aws/acm"

  acm_certificate       = var.acm_certificate
  route53_zone_settings = var.route53_zone_settings

  project_name = var.project_name
  env          = var.env
  tags         = var.tags
}
