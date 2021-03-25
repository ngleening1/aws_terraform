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

# Create security groups for RDS
resource "aws_security_group" "rds-private-security-group" {
  name        = "RDS-Private-SG"
  description = "RDS postgres server security group"
  vpc_id      = data.terraform_remote_state.infrastructure.outputs.vpc_id

  # Only postgres in
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a DB subnet group
resource "aws_db_subnet_group" "rds-db-subnet-group" {
  name       = "main"
  subnet_ids = [data.terraform_remote_state.infrastructure.outputs.private_subnet_id1,
                data.terraform_remote_state.infrastructure.outputs.private_subnet_id2]

  tags = {
    Name = "RDS DB subnet group"
  }
}

# Create RDS
resource "aws_db_instance" "postgres_db" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "12.5"
  instance_class         = "db.t2.micro"
  identifier             = "postgresdb"
  name                   = "postgresdb"
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.rds-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds-private-security-group.id]
  skip_final_snapshot    = true

  depends_on = ["aws_security_group.rds-private-security-group", "aws_db_subnet_group.rds-db-subnet-group"]
}