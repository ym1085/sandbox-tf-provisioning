locals {
  project_name = var.project_name               # 프로젝트 이름
  env          = var.env                        # 환경변수
  az_count     = length(var.availability_zones) # 가용영역 개수

  # ECS Security Group Ingress Rule (CIDR 기반)
  ecs_sg_cidr_ingress = {
    for item in flatten([
      for key, rule in var.ecs_sg_rules : [
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

  # ECS Security Group Egress Rule (CIDR 기반)
  ecs_sg_cidr_egress = {
    for item in flatten([
      for key, rule in var.ecs_sg_rules : [
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

  # ECS Security Group Ingress Rule (Security Group 기반)
  ecs_sg_sg_ingress = {
    for item in flatten([
      for key, rule in var.ecs_sg_rules : [
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

  # ECS Security Group Egress Rule (Security Group 기반)
  ecs_sg_sg_egress = {
    for item in flatten([
      for key, rule in var.ecs_sg_rules : [
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

  ecs_sg_ingress_all = merge(local.ecs_sg_cidr_ingress, local.ecs_sg_sg_ingress)
  ecs_sg_egress_all  = merge(local.ecs_sg_cidr_egress, local.ecs_sg_sg_egress)

  # ECS Task Definition Container Flat
  task_definition_container_flat = {
    for key, values in var.ecs_task_definitions : key => [
      for container in values.containers : {
        name   = "${container.name}-${container.env}"
        image  = "${container.image}-${container.env}:${container.version}"
        cpu    = container.cpu
        memory = container.memory

        portMappings = container.port != 0 ? [{
          containerPort = container.port
          hostPort      = container.port
          protocol      = container.protocol
        }] : []

        environment = [
          for env_key, env_value in container.env_variables : {
            name  = env_key
            value = env_value
          }
        ]

        mount_points = container.mount_points

        healthCheck = {
          command  = ["CMD-SHELL", container.health_check.command]
          interval = container.health_check.interval
          timeout  = container.health_check.timeout
          retries  = container.health_check.retries
        }
      }
    ]
  }
}
