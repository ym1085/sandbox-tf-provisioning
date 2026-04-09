# modules/aws/compute/ec2/outputs.tf

output "ec2_security_group_id" {
  description = "EC2 보안그룹 ID 목록"
  value = {
    for key, value in aws_security_group.ec2_security_group : key => value.id
  }
}
