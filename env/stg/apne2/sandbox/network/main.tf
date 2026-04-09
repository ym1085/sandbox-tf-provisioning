# env/stg/apne2/sandbox/network/main.tf

module "network" {
  source = "../../../../../modules/aws/network"

  vpc_cidr             = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones

  project_name = var.project_name
  env          = var.env
  tags         = var.tags
}
