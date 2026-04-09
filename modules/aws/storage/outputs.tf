# modules/aws/storage/outputs.tf

output "s3_bucket_names" {
  description = "생성된 S3 버킷명 목록"
  value = {
    for key, value in aws_s3_bucket.s3 : key => value.bucket
  } 
}
