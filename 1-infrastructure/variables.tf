variable "region" {
  default = "ap-southeast-1"
  description = "AWS Region"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "VPC CIDR Block"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
}

variable "private_subnet1_cidr" {
  description = "Private Subnet CIDR"
}

variable "private_subnet2_cidr" {
  description = "Private Subnet CIDR"
}