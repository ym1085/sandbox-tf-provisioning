# env/stg/apne2/sandbox/iam/main.tf

module "iam" {
  source = "../../../../modules/aws/iam"

  iam_custom_role       = var.iam_custom_role
  iam_custom_policy     = var.iam_custom_policy
  iam_managed_policy    = var.iam_managed_policy
  iam_policy_attachment = var.iam_policy_attachment
  iam_instance_profile  = var.iam_instance_profile

  tags = var.tags
}
