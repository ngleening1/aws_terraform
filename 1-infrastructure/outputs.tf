output "vpc_id" {
  value = aws_vpc.production-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.production-vpc.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public-subnet.id
}

output "private_subnet_id1" {
  value = aws_subnet.private-subnet1.id
}

output "private_subnet_id2" {
  value = aws_subnet.private-subnet2.id
}