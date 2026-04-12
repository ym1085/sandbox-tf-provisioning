# env/stg/apne2/sandbox/06-cicd/main.tf

module "cicd" {
  source = "../../../../../modules/aws/cicd/codedeploy"

  codedeploy_app               = var.codedeploy_app
  codedeploy_deployment_group  = var.codedeploy_deployment_group
  codedeploy_deployment_config = var.codedeploy_deployment_config

  service_role_arn = data.terraform_remote_state.iam.outputs.iam_role_arns["sandbox-codedeploy-service-role"]
  alb_listener_arn = data.terraform_remote_state.elb.outputs.alb_listener_arn

  project_name = var.project_name
  env          = var.env
  tags         = var.tags
}
