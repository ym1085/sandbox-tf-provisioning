# EC2 Security Group
resource "aws_security_group" "ec2_security_group" {
  for_each = var.ec2_security_group

  name        = each.value.security_group_name
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${each.value.security_group_name}-${each.value.env}"
  })
}

# EC2 보안그룹 Ingress 규칙
resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ingress_rules" {
  for_each = local.ec2_sg_ingress_all

  description                  = each.value.description
  security_group_id            = aws_security_group.ec2_security_group[each.value.security_group_key].id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

# EC2 보안그룹 Egress 규칙
resource "aws_vpc_security_group_egress_rule" "ec2_sg_egress_rules" {
  for_each = local.ec2_sg_egress_all

  description                  = each.value.description
  security_group_id            = aws_security_group.ec2_security_group[each.value.security_group_key].id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

# EC2 instance
resource "aws_instance" "ec2" {
  for_each = {
    for key, value in var.ec2_instance : key => value if value.create_yn
  }

  ami                  = data.aws_ami.amazon_ami[each.key].id # AMI 지정(offer: 기존 AWS 제공, custom: 생성한 AMI)
  instance_type        = each.value.instance_type             # EC2 인스턴스 타입 지정
  private_ip           = try(each.value.private_ip, null)     # EC2 private ip 지정
  iam_instance_profile = try(var.iam_instance_profile[each.value.iam_instance_profile].name, null)

  # EC2가 위치할 VPC Subnet 영역 지정(az-2a, az-2b)
  subnet_id = lookup(
    {
      "public"  = try(element(var.public_subnet_ids, index(var.availability_zones, each.value.availability_zones)), var.public_subnet_ids[0]),
      "private" = try(element(var.private_subnet_ids, index(var.availability_zones, each.value.availability_zones)), var.private_subnet_ids[0])
    },
    each.value.subnet_type,
    var.public_subnet_ids[0]
  )

  associate_public_ip_address = each.value.associate_public_ip_address # 퍼블릭 IP 할당 여부 지정(true면 공인 IP 부여 -> 고정 IP 아님)
  disable_api_termination     = each.value.disable_api_termination     # TRUE인 경우 콘솔/API로 삭제 불가

  key_name = data.aws_key_pair.key_pair[each.value.key_pair_name].key_name # SSH key pair 지정

  vpc_security_group_ids = [
    aws_security_group.ec2_security_group[each.value.security_group_key].id
  ]
  #iam_instance_profile = xxxx # EC2에 IAM 권한이 필요한 경우 활성화

  # lookup(map, key, default)
  user_data = (
    lookup(each.value, "script_file_name", null) != null &&
    lookup(each.value, "script_file_name", "") != ""
  ) ? file("${path.module}/script/${each.value.script_file_name}") : null

  dynamic "root_block_device" {
    for_each = each.value.root_block_device != null ? [each.value.root_block_device] : []
    content {
      volume_type           = root_block_device.value.volume_type
      volume_size           = root_block_device.value.volume_size
      delete_on_termination = root_block_device.value.delete_on_termination
      encrypted             = root_block_device.value.encrypted
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = all # Terraform EC2 생성 후 전부 무시
  }

  tags = merge(var.tags, {
    Name = "${each.value.instance_name}-${each.value.env}"
  })
}
