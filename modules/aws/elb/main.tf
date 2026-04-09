# ALB Security Group
resource "aws_security_group" "alb_security_group" {
  for_each = var.alb_security_group

  name        = each.value.security_group_name
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${each.value.security_group_name}-${each.value.env}"
  })
}

# ALB Security Group Ingress Rule
resource "aws_vpc_security_group_ingress_rule" "alb_ingress_rule" {
  for_each = local.alb_sg_ingress_all

  description                  = each.value.description
  security_group_id            = aws_security_group.alb_security_group[each.value.security_group_key].id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

# ALB Security Group Egress Rule
resource "aws_vpc_security_group_egress_rule" "alb_egress_rule" {
  for_each = local.alb_sg_egress_all

  description                  = each.value.description
  security_group_id            = aws_security_group.alb_security_group[each.value.security_group_key].id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

# Application Load Balancer
resource "aws_lb" "alb" {
  for_each = var.alb

  name               = "${each.value.name}-${each.value.env}"
  internal           = each.value.internal
  load_balancer_type = each.value.load_balancer_type
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb_security_group[each.value.security_group_name].id]

  enable_deletion_protection       = each.value.enable_deletion_protection
  enable_cross_zone_load_balancing = each.value.enable_cross_zone_load_balancing
  idle_timeout                     = each.value.idle_timeout

  tags = merge(var.tags, {
    Name = "${each.value.name}-${each.value.env}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# ALB Listener
resource "aws_lb_listener" "alb_listener" {
  for_each = var.alb_listener

  load_balancer_arn = aws_lb.alb[each.value.load_balancer_arn].arn
  port              = each.value.port
  protocol          = each.value.protocol

  dynamic "default_action" {
    for_each = each.value.default_action.type == "forward" ? [1] : []
    content {
      type             = each.value.default_action.type
      target_group_arn = try(aws_lb_target_group.target_group[each.value.default_action.target_group_arn].arn, null)
    }
  }

  dynamic "default_action" {
    for_each = each.value.default_action.type == "fixed-response" ? [1] : []
    content {
      type = each.value.default_action.type
      fixed_response {
        content_type = each.value.default_action.fixed_response.content_type
        message_body = each.value.default_action.fixed_response.message_body
        status_code  = each.value.default_action.fixed_response.status_code
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${each.value.name}-${each.value.env}"
  })

  depends_on = [aws_lb.alb]

  lifecycle {
    create_before_destroy = true
  }
}

# ALB Listener Rule
resource "aws_lb_listener_rule" "alb_listener_rule" {
  for_each = var.alb_listener_rule

  listener_arn = aws_lb_listener.alb_listener[each.value.alb_listener_name].arn
  priority     = each.value.priority

  condition {
    path_pattern {
      values = each.value.path
    }
  }

  action {
    type             = each.value.type
    target_group_arn = aws_lb_target_group.target_group[each.value.target_group_name].arn
  }

  depends_on = [
    aws_lb.alb,
    aws_lb_listener.alb_listener
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# ALB Target Group
resource "aws_lb_target_group" "target_group" {
  for_each = var.target_group

  vpc_id      = var.vpc_id
  name        = "${each.value.name}-${each.value.env}"
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = each.value.target_type

  health_check {
    path                = each.value.health_check.path
    enabled             = each.value.health_check.enabled
    healthy_threshold   = each.value.health_check.healthy_threshold
    interval            = each.value.health_check.interval
    port                = each.value.health_check.port
    protocol            = each.value.health_check.protocol
    timeout             = each.value.health_check.timeout
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
  }

  tags = merge(var.tags, {
    Name = "${each.value.name}-${each.value.env}"
  })

  lifecycle {
    create_before_destroy = true
  }
}
