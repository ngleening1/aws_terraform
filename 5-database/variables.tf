variable "region" {
  default = "ap-southeast-1"
  description = "AWS Region"
}

variable "remote_state_bucket" {
  description = "Bucket name for layer 1 - Infrastructure"
}

variable "remote_state_key" {
  description = "Key name for layer 1 - Infrastructure"
}

variable "rds_username" {
  description = "Username for Postgres RDS database"
}

variable "rds_password" {
  description = "Password for Postgres RDS database"
}