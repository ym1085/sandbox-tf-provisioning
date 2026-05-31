# env/stg/apne2/sandbox/network/outputs.tf

# vpc
output "vpc_id" {
  description = "생성된 VPC ID"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  value       = module.network.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 목록"
  value       = module.network.private_subnet_ids
}

output "public_route_table_id" {
  description = "퍼블릭 라우트 테이블 ID"
  value       = module.network.public_route_table_id
}

output "private_route_table_id" {
  description = "프라이빗 라우트 테이블 ID"
  value       = module.network.private_route_table_id
}
