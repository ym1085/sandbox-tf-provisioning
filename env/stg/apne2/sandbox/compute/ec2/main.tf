# env/stg/apne2/sandbox/compute/ec2/main.tf

module "ec2" {
  source = "../../../../../../modules/aws/compute/ec2"

  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.network.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  ec2_instance       = var.ec2_instance
  ec2_security_group = var.ec2_security_group
  ec2_sg_rules       = var.ec2_sg_rules
  ec2_key_pair       = var.ec2_key_pair

  iam_instance_profile = data.terraform_remote_state.iam.outputs.iam_instance_profile

  env                = var.env
  tags               = var.tags
  availability_zones = var.availability_zones
}
