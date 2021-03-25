provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

# Get the infrastructure terraform script from S3 bucket
data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    region = var.region
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
  }
}

# Sagemaker private security group
resource "aws_security_group" "sagemaker-private-security-group" {
  name        = "Sagemaker-Private-SG"
  vpc_id      = data.terraform_remote_state.infrastructure.outputs.vpc_id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.private_ip_address]
    description = "Only allow own IP address to run sagemaker"
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create IAM role
resource "aws_iam_role" "sagemaker-iam-role" {
  name               = "Sagemaker-IAM-Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["sagemaker.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

# Attaching Policies to IAM Role
resource "aws_iam_role_policy_attachment" "ec2-role-policy-attach" {
  count      = length(var.ec2_policies)
  policy_arn = element(var.ec2_policies, count.index)
  role       = aws_iam_role.sagemaker-iam-role.name
}

resource "aws_sagemaker_notebook_instance" "rds-analytics" {
  name            = "RDS-Notebook"
  role_arn        = aws_iam_role.sagemaker-iam-role.arn
  instance_type   = "ml.t2.medium"
  subnet_id       = data.terraform_remote_state.infrastructure.outputs.private_subnet_id1
  security_groups = [aws_security_group.sagemaker-private-security-group.id]

  depends_on = [aws_iam_role.sagemaker-iam-role]
}