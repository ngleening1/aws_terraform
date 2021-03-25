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

# Create EC2 private security group
resource "aws_security_group" "ec2-private-security-group" {
  name        = "EC2-Private-SG"
  description = "Only allow public SG resources to access instance"
  vpc_id      = data.terraform_remote_state.infrastructure.outputs.vpc_id

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = [var.private_ip_address]
    description = "Only allow own IP address to access instance"
  }
  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow health checks"
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create IAM role
resource "aws_iam_role" "ec2-iam-role" {
  name               = "EC2-IAM-Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
}

# Attach Policies to IAM Role
resource "aws_iam_role_policy_attachment" "ec2-role-policy-attach" {
  count      = length(var.ec2_policies)
  policy_arn = element(var.ec2_policies, count.index)
  role       = aws_iam_role.ec2-iam-role.name
}

# Create IAM Instance profile
resource "aws_iam_instance_profile" "ec2-instance-profile" {
  name = "EC2-IAM-Instance-Profile"
  role = aws_iam_role.ec2-iam-role.name
}

# Launch EC2 Instance
resource "aws_instance" "ec2-instance" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = data.terraform_remote_state.infrastructure.outputs.private_subnet_id1
  iam_instance_profile   = aws_iam_instance_profile.ec2-instance-profile.name
  vpc_security_group_ids = [aws_security_group.ec2-private-security-group.id]

  tags = {
    Name = "EC2 Instance to retrieve data from SFTP Server"
  }

  depends_on = ["aws_security_group.ec2-private-security-group"]
}
