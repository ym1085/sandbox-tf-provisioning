locals {

  # EC2 ingress rules (CIDR 기반)
  ec2_sg_cidr_ingress = {
    for item in flatten([
      for key, rule in var.ec2_sg_rules : [
        for cidr in rule.cidr_ipv4 : {
          key                = "${key}__${replace(cidr, "/", "_")}"
          security_group_key = rule.security_group_key
          description        = rule.description
          from_port          = rule.from_port
          to_port            = rule.to_port
          ip_protocol        = rule.ip_protocol
          cidr_ipv4          = cidr
        }
      ] if rule.type == "ingress" && rule.cidr_ipv4 != null
    ]) : item.key => item
  }

  # EC2 egress rules (CIDR 기반)
  ec2_sg_cidr_egress = {
    for item in flatten([
      for key, rule in var.ec2_sg_rules : [
        for cidr in rule.cidr_ipv4 : {
          key                = "${key}__${replace(cidr, "/", "_")}"
          security_group_key = rule.security_group_key
          description        = rule.description
          from_port          = rule.from_port
          to_port            = rule.to_port
          ip_protocol        = rule.ip_protocol
          cidr_ipv4          = cidr
        }
      ] if rule.type == "egress" && rule.cidr_ipv4 != null
    ]) : item.key => item
  }

  # EC2 ingress rules (Security Group Reference ID 기반)
  ec2_sg_ingress = {
    for item in flatten([
      for key, rule in var.ec2_sg_rules : [
        for sg in rule.referenced_security_group_id : {
          key                          = "${key}__${sg}"
          security_group_key           = rule.security_group_key
          description                  = rule.description
          from_port                    = rule.from_port
          to_port                      = rule.to_port
          ip_protocol                  = rule.ip_protocol
          referenced_security_group_id = sg
        }
      ] if rule.type == "ingress" && rule.referenced_security_group_id != null
    ]) : item.key => item
  }

  # EC2 egress rules (Security Group Reference ID 기반)
  ec2_sg_egress = {
    for item in flatten([
      for key, rule in var.ec2_sg_rules : [
        for sg in rule.referenced_security_group_id : {
          key                          = "${key}__${sg}"
          security_group_key           = rule.security_group_key
          description                  = rule.description
          from_port                    = rule.from_port
          to_port                      = rule.to_port
          ip_protocol                  = rule.ip_protocol
          referenced_security_group_id = sg
        }
      ] if rule.type == "egress" && rule.referenced_security_group_id != null
    ]) : item.key => item
  }

  ec2_sg_ingress_all = merge(local.ec2_sg_cidr_ingress, local.ec2_sg_ingress)
  ec2_sg_egress_all  = merge(local.ec2_sg_cidr_egress, local.ec2_sg_egress)
}
