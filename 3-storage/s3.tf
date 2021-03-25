provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

# Create S3 raw bucket
resource "aws_s3_bucket" "raw-bucket" {
  bucket = var.raw_bucket_name
  acl    = "private"
}

# Create bucket folders
resource "aws_s3_bucket_object" "raw-bucket-folder" {
  bucket = aws_s3_bucket.raw-bucket.id
  acl    = "private"
  key    = var.bucket_folder_key
}

# Create S3 archival bucket
resource "aws_s3_bucket" "archival-bucket" {
  bucket = var.archival_bucket_name
  acl    = "private"
}

# Create bucket folders
resource "aws_s3_bucket_object" "archival-bucket-folder" {
  bucket = aws_s3_bucket.archival-bucket.id
  acl    = "private"
  key    = var.bucket_folder_key
}

# Create S3 schema bucket
resource "aws_s3_bucket" "schema-bucket" {
  bucket = var.schema_bucket_name
  acl    = "private"
}

# Create bucket folders
resource "aws_s3_bucket_object" "schema-bucket-folder" {
  bucket = aws_s3_bucket.schema-bucket.id
  acl    = "private"
  key    = var.bucket_folder_key
}