# env/stg/apnortheast2/commerce/storage/outputs.tf

output "s3_bucket_names" {
  description = "생성된 S3 버킷명 목록"
  value       = module.s3.s3_bucket_names
}
