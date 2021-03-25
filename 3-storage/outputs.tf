output "raw_bucket_id" {
  value = aws_s3_bucket.raw-bucket.id
}

output "archival_bucket_id" {
  value = aws_s3_bucket.archival-bucket.id
}

output "schema_bucket_id" {
  value = aws_s3_bucket.schema-bucket.id
}

output "bucket_path" {
  value = aws_s3_bucket_object.raw-bucket-folder.id
}