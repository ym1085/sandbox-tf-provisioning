# ECS Security Group
resource "aws_security_group" "ecs_security_group" {
  for_each = var.ecs_security_group

  name        = each.value.security_group_name
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${each.value.security_group_name}-${each.value.env}"
  })
}

# ECS Security Group Ingress Rule
resource "aws_vpc_security_group_ingress_rule" "ecs_security_group_ingress_rule" {
  for_each = local.ecs_sg_ingress_all

  description                  = each.value.description
  security_group_id            = aws_security_group.ecs_security_group[each.value.security_group_key].id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

# ECS Security Group Egress Rule
resource "aws_vpc_security_group_egress_rule" "ecs_security_group_egress_rule" {
  for_each = local.ecs_sg_egress_all

  description                  = each.value.description
  security_group_id            = aws_security_group.ecs_security_group[each.value.security_group_key].id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

# ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  for_each = var.ecs_cluster

  name = "${each.value.cluster_name}-${each.value.env}"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${each.value.cluster_name}-${each.value.env}"
  })
}

# ECS task definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  for_each = var.ecs_task_definitions

  family                   = "${each.value.task_family}-${each.value.env}"
  cpu                      = each.value.task_total_cpu
  memory                   = each.value.task_total_memory
  network_mode             = each.value.network_mode
  requires_compatibilities = [each.value.launch_type] # EC2, FARATE

  # ECS Task Role & Task Exec Role 설정
  task_role_arn      = var.ecs_task_role_arn
  execution_role_arn = var.ecs_task_exec_role_arn

  runtime_platform {
    operating_system_family = each.value.runtime_platform_oprating_system_family
    cpu_architecture        = each.value.runtime_platform_cpu_architecture
  }

  lifecycle {
    ignore_changes = [container_definitions]
  }

  # task_definitions.tpl 파일에 있는 mountPoints 이름을 volume으로 사용
  # ECS Fargate의 경우 volume 사용이 불가능하여, bind mount(host path) 사용
  volume {
    name = each.value.volume.name
  }

  # ECS 임시 휘발성 볼륨 지정
  ephemeral_storage {
    size_in_gib = each.value.ephemeral_storage
  }

  # ECS Task Definition 파일을 읽어서
  container_definitions = jsonencode(local.task_definition_container_flat[each.key])

  tags = merge(var.tags, {
    Name = "${each.value.task_family}-${each.value.env}"
  })
}

# ECS service
resource "aws_ecs_service" "ecs_service" {
  for_each = var.ecs_service

  cluster                           = "${each.value.cluster_name}-${each.value.env}"
  name                              = "${each.value.service_name}-${each.value.env}"
  launch_type                       = each.value.launch_type
  desired_count                     = each.value.desired_count
  health_check_grace_period_seconds = each.value.health_check_grace_period_sec
  task_definition                   = aws_ecs_task_definition.ecs_task_definition[each.value.task_definitions].arn

  network_configuration {
    subnets          = each.value.subnets == "public" ? var.public_subnet_ids : var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_security_group[each.value.security_group_name].id]
    assign_public_ip = each.value.assign_public_ip
  }

  load_balancer {
    target_group_arn = lookup(var.alb_tg_arn, each.value.target_group_arn, null)
    container_name   = "${each.value.container_name}-${each.value.env}"
    container_port   = each.value.container_port
  }

  dynamic "deployment_circuit_breaker" {
    for_each = each.value.deployment_circuit_breaker ? [1] : []
    content {
      enable   = true
      rollback = true
    }
  }

  # (ECS | CODE_DEPLOY | EXTERNAL)
  deployment_controller {
    type = each.value.deployment_controller
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_count, load_balancer]
  }

  depends_on = [
    aws_ecs_cluster.ecs_cluster,
    aws_ecs_task_definition.ecs_task_definition
  ]

  tags = merge(var.tags, {
    Name = "${each.value.service_name}-${each.value.env}"
  })
}

# ECS autoscaling appautoscaling target
resource "aws_appautoscaling_target" "ecs_target" {
  for_each = var.ecs_appautoscaling_target

  min_capacity       = each.value.min_capacity       # 최소 Task 2개가 항상 실행되도록 설정
  max_capacity       = each.value.max_capacity       # 최대 Task 6개까지 증가 할 수 있도록 설정
  resource_id        = each.value.resource_id        # AG를 적용할 대상 리소스 지정, 여기서는 ECS 서비스 ARN 형식의 일부 기재
  scalable_dimension = each.value.scalable_dimension # 조정할 수 있는 AWS 리소스의 특정 속성을 지정하는 필드
  service_namespace  = each.value.service_namespace  # ECS namespace 지정

  depends_on = [
    aws_ecs_service.ecs_service
  ]
}

# ECS autoscaling scale out policy
resource "aws_appautoscaling_policy" "ecs_policy_scale_out" {
  for_each = var.ecs_appautoscaling_target_policy

  name               = each.value.scale_out.name                                         # AutoScaling 정책 이름
  policy_type        = each.value.scale_out.policy_type                                  # AutoScaling 정책 타입(How to scale out?)
  resource_id        = aws_appautoscaling_target.ecs_target[each.key].resource_id        # AutoScaling이 적용될 ECS 서비스 ID
  scalable_dimension = aws_appautoscaling_target.ecs_target[each.key].scalable_dimension # AutoScaling이 적용될 리소스의 스케일링 속성(ecs:service:DesiredCount)
  service_namespace  = aws_appautoscaling_target.ecs_target[each.key].service_namespace  # AWS 서비스 네임스페이스 (ecs, dynamodb, sagemaker 등)

  step_scaling_policy_configuration {
    adjustment_type         = each.value.scale_out.step_scaling_policy_conf.adjustment_type         # AutoScaling 조정 방식(PercentChangeInCapacity)
    cooldown                = each.value.scale_out.step_scaling_policy_conf.cooldown                # Auto Scaling 이벤트 후 다음 이벤트까지 대기 시간 (초)
    metric_aggregation_type = each.value.scale_out.step_scaling_policy_conf.metric_aggregation_type # 측정 지표의 집계 방식 (Average 등)

    dynamic "step_adjustment" {
      for_each = each.value.scale_out.step_scaling_policy_conf.step_adjustment

      content {
        metric_interval_lower_bound = step_adjustment.value.metric_interval_lower_bound
        metric_interval_upper_bound = step_adjustment.value.metric_interval_upper_bound
        scaling_adjustment          = step_adjustment.value.scaling_adjustment
      }
    }
  }
}

# ECS scaleout policy alarm
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_scale_out_alert" {
  for_each = var.ecs_cpu_scale_out_alert

  alarm_name          = each.value.alarm_name          # Cloudwatch 알람 이름
  comparison_operator = each.value.comparison_operator # 메트릭 값과 임계값 비교할 때 사용할 연산자 지정(GreaterThanThreshold, LessThanThreshold)
  evaluation_periods  = each.value.evaluation_periods  # 평가 기간(1)
  metric_name         = each.value.metric_name         # 메트릭 이름 지정 -> CPUUtilization
  namespace           = each.value.namespace           # 메트릭이 속한 네임스페이스 지정
  period              = each.value.period              # 메트릭 데이터 집계 간격(초) 지정
  statistic           = each.value.statistic           # 메트릭 통계 방식 지정(Average, Sum)
  threshold           = each.value.threshold           # 알람 발동을 위한 임계값 지정

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster[each.value.dimensions.cluster_name].name
    ServiceName = aws_ecs_service.ecs_service[each.value.dimensions.service_name].name
  }

  # 알람 발동 시 어떤 정책을 사용할지 연결
  alarm_actions = [
    aws_appautoscaling_policy.ecs_policy_scale_out[each.key].arn
  ]

  tags = merge(var.tags, {
    Name = "${each.value.alarm_name}-${each.value.env}"
  })
}
