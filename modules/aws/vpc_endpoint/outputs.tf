# modules/aws/vpc_endpoint/outputs.tf

output "vpc_endpoint_gateway_ids" {
  description = "생성된 VPC Endpoint Gateway ID 목록"
  value = {
    for key, value in aws_vpc_endpoint.vpc_endpoint_gateway : key => value.id
  }
}

output "vpc_endpoint_interface_ids" {
  description = "생성된 VPC Endpoint Interface ID 목록"
  value = {
    for key, value in aws_vpc_endpoint.vpc_endpoint_interface : key => value.id
  }
}
