# VPC Endpoint Gateway Type
resource "aws_vpc_endpoint" "vpc_endpoint_gateway" {
  for_each = var.vpc_endpoint_gateway

  vpc_id            = var.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.vpc_endpoint_type
  route_table_ids   = var.private_route_table_ids

  tags = merge(var.tags, {
    Name = "${each.value.endpoint_name}-${local.env}"
  })
}

# VPC Endpoint Interface Type
resource "aws_vpc_endpoint" "vpc_endpoint_interface" {
  for_each = var.vpc_endpoint_interface

  vpc_id              = var.vpc_id
  service_name        = each.value.service_name
  vpc_endpoint_type   = each.value.vpc_endpoint_type
  private_dns_enabled = each.value.private_dns_enabled
  security_group_ids  = [for sg_name in each.value.security_group_name : lookup(var.security_group_ids, sg_name)]
  subnet_ids          = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${each.value.endpoint_name}-${local.env}"
  })
}
