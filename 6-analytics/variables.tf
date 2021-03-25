variable "region" {
  default = "ap-southeast-1"
}

variable "remote_state_bucket" {
  description = "Bucket name for layer 1 - Infrastructure"
}

variable "remote_state_key" {
  description = "Key name for layer 1 - Infrastructure"
}

variable "private_ip_address" {
  description = "IP address of your own device to allow SSH access"
}

variable "ec2_policies" {
  default = ["arn:aws:iam::aws:policy/AmazonSageMakerFullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
  ]
}