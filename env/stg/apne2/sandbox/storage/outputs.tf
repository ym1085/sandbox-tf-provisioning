# env/stg/apne2/sandbox/storage/outputs.tf

output "s3_bucket_names" {
  description = "생성된 S3 버킷명 목록"
  value       = module.storage.s3_bucket_names
}
