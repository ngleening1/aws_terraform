# AWS Terraform

IaC using Terraform to build and manage AWS cloud infrastructure

## 1-infrastructure

This layer consists of:
- VPCs
- Subnets
    - Public Subnet
    - Private Subnet 1 (For EC2, Lambda, RDS, Sagemaker)
    - Private Subnet 2 (For RDS)
- Route tables for Subnets
- Internet Gateway
- NAT Gateway

## 2-app

This layer consists of:
- EC2 Security Group
- EC2 IAM Role
- EC2 Instance (Amazon Linux 2 AMI)
- ECR

## 3-storage

This layer consists of:
- S3 Raw Bucket
- S3 Archival Bucket
- S3 Schema Bucket

## 4-processing

This layer consists of:
- Lambda Security Group
- Lambda IAM Role
- CheckSchema + AppendtoDB Lambda Function
- SNS IAM Role
- SNS Topic

## 5-database

This layer consists of:
- RDS Security Group
- RDS IAM Role
- RDS Instance (Postgres v12.5)

## 6-analytics

This layer consists of:
- Sagemaker Security Group
- Sagemaker IAM Role
- Sagemaker Notebook Instance
