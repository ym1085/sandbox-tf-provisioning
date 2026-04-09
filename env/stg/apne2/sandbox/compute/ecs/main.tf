# env/stg/devops/ap-northeast-2/main.tf

module "ecs" {
  source = "../../../../../../modules/aws/compute/ecs"

  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.network.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr

  ecs_cluster                      = var.ecs_cluster
  ecs_task_definitions             = var.ecs_task_definitions
  ecs_service                      = var.ecs_service
  ecs_appautoscaling_target        = var.ecs_appautoscaling_target
  ecs_appautoscaling_target_policy = var.ecs_appautoscaling_target_policy
  ecs_cpu_scale_out_alert          = var.ecs_cpu_scale_out_alert

  ecs_task_role_arn      = data.terraform_remote_state.iam.outputs.iam_role_arns["sandbox-ecs-task-role"]
  ecs_task_exec_role_arn = data.terraform_remote_state.iam.outputs.iam_role_arns["sandbox-ecs-task-exec-role"]
  ecs_security_group     = var.ecs_security_group
  ecs_sg_rules           = var.ecs_sg_rules

  alb_tg_arn       = data.terraform_remote_state.elb.outputs.alb_target_group_arn
  alb_listener_arn = data.terraform_remote_state.elb.outputs.alb_listener_arn

  project_name       = var.project_name
  availability_zones = var.availability_zones
  aws_region         = var.aws_region
  aws_account        = var.aws_account
  env                = var.env
  tags               = var.tags
}
