# modules/aws/route53/outputs.tf

output "route53_zone_id" {
  description = "Route53 Zone ID 맵"
  value = merge(
    { for k, v in aws_route53_zone.create_route53_zone : k => v.zone_id },
    { for k, v in data.aws_route53_zone.import_route53_zone : k => v.zone_id }
  )
}
