resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

resource "aws_eip" "public1" {
  vpc = true
}

resource "aws_eip" "public2" {
  vpc = true
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet1.cidr_block
  availability_zone       = var.public_subnet1.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet2.cidr_block
  availability_zone       = var.public_subnet2.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet1.cidr_block
  availability_zone       = var.private_subnet1.availability_zone
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet2.cidr_block
  availability_zone       = var.private_subnet2.availability_zone
  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "public1" {
  allocation_id = aws_eip.public1.id
  subnet_id     = aws_subnet.public1.id
}

resource "aws_nat_gateway" "public2" {
  allocation_id = aws_eip.public2.id
  subnet_id     = aws_subnet.public2.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "privat1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public1.id
  }
}

resource "aws_route_table" "privat2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public2.id
  }
}

resource "aws_route_table_association" "public" {
  for_each = {
    first  = aws_subnet.public1.id
    second = aws_subnet.public2.id
  }

  route_table_id = aws_route_table.public.id
  subnet_id      = each.value
}

resource "aws_route_table_association" "private1" {
  route_table_id = aws_route_table.privat1.id
  subnet_id      = aws_subnet.private1.id
}

resource "aws_route_table_association" "private2" {
  route_table_id = aws_route_table.privat2.id
  subnet_id      = aws_subnet.private2.id
}
