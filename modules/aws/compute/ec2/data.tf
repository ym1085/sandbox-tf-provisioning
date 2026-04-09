# EC2 amazon ami
data "aws_ami" "amazon_ami" {
  for_each = var.ec2_instance

  most_recent = true
  owners      = [each.value.owners]

  dynamic "filter" {
    for_each = each.value.filter

    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}

# EC2 key pair
data "aws_key_pair" "key_pair" {
  for_each = var.ec2_key_pair

  key_name = each.value.name

  tags = merge(var.tags, {
    Name = "${each.value.name}-${each.value.env}"
  })
}
