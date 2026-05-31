# env/stg/apne2/sandbox/04-elb/main.tf

module "elb" {
  source = "../../../../../modules/aws/elb"

  alb                = var.alb
  alb_listener       = var.alb_listener
  alb_listener_rule  = var.alb_listener_rule
  target_group       = var.target_group
  alb_security_group = var.alb_security_group
  alb_sg_rules       = var.alb_sg_rules

  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids

  project_name       = var.project_name
  env                = var.env
  availability_zones = var.availability_zones
  tags               = var.tags
}
