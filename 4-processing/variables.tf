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

variable "private_ip_address" {
  description = "IP address of your own device to allow SSH access"
}

variable "lambda_policies" {
  default = ["arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole", # To allow lambda to be within VPC
  ]
}

variable "sns_policies" {
  default = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  ]
}