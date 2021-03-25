variable "region" {
  default = "ap-southeast-1"
  description = "AWS Region"
}

variable "raw_bucket_name" {
  description = "Name for raw bucket"
}

variable "archival_bucket_name" {
  description = "Name for archival bucket"
}

variable "schema_bucket_name" {
  description = "Name for schema bucket"
}


variable "bucket_folder_key" {
  description = "Folder path for buckets"
}