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

# Lambda private security group
resource "aws_security_group" "lambda-private-security-group" {
  name        = "Lambda-Private-SG"
  vpc_id      = data.terraform_remote_state.infrastructure.outputs.vpc_id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.private_ip_address]
    description = "Only allow own IP address to run lambda"
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "lambda-iam-role" {
  name = "Lambda-IAM-Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attaching policies to IAM role
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attach" {
  count      = length(var.lambda_policies)
  policy_arn = element(var.lambda_policies, count.index)
  role       = aws_iam_role.lambda-iam-role.name
}

# Specify location to place Lambda zip file
locals {
  CheckSchema_zip_location = "outputs/CheckSchema.zip"
}

# Load in CheckSchema lambda function
data "archive_file" "CheckSchema" {
  source_file = "CheckSchema.zip"
  output_path = local.CheckSchema_zip_location
  type        = "zip"
}

# Creating lambda function
resource "aws_lambda_function" "check-schema-lambda" {
  filename      = local.CheckSchema_zip_location
  function_name = "CheckSchema"
  role          = aws_iam_role.lambda-iam-role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.6"
  vpc_config {
    security_group_ids = [aws_security_group.lambda-private-security-group.id]
    subnet_ids         = [data.terraform_remote_state.infrastructure.outputs.private_subnet_id1]
  }
}