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
  default = ["arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  ]
}

variable "ec2_ami" {
  description = "AMI to launch"
}

variable "ec2_instance_type" {
  description = "EC2 Instance type to launch"
}

variable "ec2_key_pair_name" {
  default = "MyEC2KeyPair"
  description = "Key Pair to use to connect to EC2 Instance"
}