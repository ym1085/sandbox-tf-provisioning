# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(var.tags, {
    Name = "${local.project_name}-vpc-${local.env}"
  })
}

# Public subnets
resource "aws_subnet" "public_subnet" {
  count = local.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${format("%s-sub-pub-%s-%02d", local.project_name, local.env, count.index + 1)}"
  })
}

# Private subnets
resource "aws_subnet" "private_subnet" {
  count = local.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name = "${format("%s-sub-pri-%s-%02d", local.project_name, local.env, count.index + 1)}"
  })
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "${local.project_name}-igw-${local.env}"
  })
}

# Public routing table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${local.project_name}-rt-pub-${local.env}"
  })
}

# Public routing table association
resource "aws_route_table_association" "public_route_table_association" {
  count = local.az_count

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [
    aws_route_table.public_route_table
  ]
}

# Private routing table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${local.project_name}-rt-pri-${local.env}"
  })
}

# Private routing table association
resource "aws_route_table_association" "private_route_table_association" {
  count = local.az_count

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id

  depends_on = [
    aws_route_table.private_route_table
  ]
}
