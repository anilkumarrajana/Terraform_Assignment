############################
# VPC
############################

resource "aws_vpc" "travelmemory_vpc" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "TravelMemory-VPC"
  }

}

############################
# Public Subnet
############################

resource "aws_subnet" "public_subnet" {

  vpc_id                  = aws_vpc.travelmemory_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "TravelMemory-Public-Subnet"
  }

}

############################
# Private Subnet
############################

resource "aws_subnet" "private_subnet" {

  vpc_id            = aws_vpc.travelmemory_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "TravelMemory-Private-Subnet"
  }

}

############################
# Internet Gateway
############################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.travelmemory_vpc.id

  tags = {
    Name = "TravelMemory-IGW"
  }

}

############################
# Elastic IP
############################

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "TravelMemory-EIP"
  }

}

############################
# NAT Gateway
############################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "TravelMemory-NAT"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]

}

############################
# Public Route Table
############################

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.travelmemory_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {

    Name = "TravelMemory-Public-RT"

  }

}

############################
# Private Route Table
############################

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.travelmemory_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id

  }

  tags = {

    Name = "TravelMemory-Private-RT"

  }

}

############################ssssssss
# Route Table Associations
############################

resource "aws_route_table_association" "public_assoc" {

  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

}

resource "aws_route_table_association" "private_assoc" {

  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id

}