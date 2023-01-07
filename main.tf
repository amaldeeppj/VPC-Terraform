# VPC creation

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    { Name = var.common_name_tag },
    var.common_tags
  )

}


# Internat Gateway creation

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { Name = var.common_name_tag },
    var.common_tags
  )

}

# Creation of public subnets 

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_names)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet_cidr["${count.index}"]
  availability_zone       = var.public_subnet_azs["${count.index}"]

  tags = merge(
    { Name = var.public_subnet_names["${count.index}"] },
    var.common_tags
  )
}


# Creation of private subnets

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_names)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnet_cidr["${count.index}"]
  availability_zone       = var.private_subnet_azs["${count.index}"]

  tags = merge(
    { Name = var.private_subnet_names["${count.index}"] },
    var.common_tags
  )
}

# Creation of elastic IP to attach with NAT gateway

resource "aws_eip" "eip" {
  vpc = true

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = merge(
    { Name = var.common_name_tag },
    var.common_tags
  )

}

# Creation of NAT gateway (To avail internet for the instances inside private subnet)

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = merge(
    { Name = var.common_name_tag },
    var.common_tags
  )

}


# Creation of public route

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    { Name = "${var.common_name_tag}-public" },
    var.common_tags
  )

}

# Creation of private route 

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    { Name = "${var.common_name_tag}-private" },
    var.common_tags
  )
}

# Public route table association with public subnets

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_names)
  subnet_id      = aws_subnet.public_subnets["${count.index}"].id
  route_table_id = aws_route_table.public_route.id
}


# Private route table association with private subnets

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_names)
  subnet_id      = aws_subnet.private_subnets["${count.index}"].id
  route_table_id = aws_route_table.private_route.id
}
