provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

# Create VPC
resource "aws_vpc" "production-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Production-VPC"
  }
}

# Create Public Subnet
resource "aws_subnet" "public-subnet" {
  cidr_block        = var.public_subnet_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Public-Subnet"
  }
}

# Create First Private Subnet - for EC2, Lambda, RDS, Sagemaker
resource "aws_subnet" "private-subnet1" {
  cidr_block        = var.private_subnet1_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Private-Subnet1"
  }
}

# Create Second Private Subnet - for RDS
resource "aws_subnet" "private-subnet2" {
  cidr_block        = var.private_subnet2_cidr
  vpc_id            = aws_vpc.production-vpc.id
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "Private-Subnet2"
  }
}

# Create Route tables
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table" "private-route-table1" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name = "Private-Route-Table1"
  }
}

resource "aws_route_table" "private-route-table2" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name = "Private-Route-Table2"
  }
}

# Assign Route Tables to Subnet
resource "aws_route_table_association" "public-subnet-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet.id
}

resource "aws_route_table_association" "private-subnet-association1" {
  route_table_id = aws_route_table.private-route-table1.id
  subnet_id      = aws_subnet.private-subnet1.id
}

resource "aws_route_table_association" "private-subnet-association2" {
  route_table_id = aws_route_table.private-route-table2.id
  subnet_id      = aws_subnet.private-subnet2.id
}

# Create Elastic IP
resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "Production-EIP"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "Production-NAT-GW"
  }

  depends_on = ["aws_eip.elastic-ip-for-nat-gw"]
}

# Associate NAT Gateway with Route Table
resource "aws_route" "nat_gw_route" {
  route_table_id         = aws_route_table.private-route-table1.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Create Internet Gateway
resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name = "Production-IGW"
  }
}

# Associate IGW with Route Table
resource "aws_route" "public-internet-gw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}