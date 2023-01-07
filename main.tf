resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true 

    tags = {
        Name = "${var.project}-${var.environment}"
    }
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id 

    tags = {
      "Name" = "${var.project}-${var.environment}"
    }
  
}

resource "aws_subnet" "public" {
    count = local.azs
    vpc_id = aws_vpc.vpc.id 
    map_public_ip_on_launch = true 
    cidr_block = cidrsubnet(var.vpc_cidr, 4, "${count.index}")
    availability_zone = data.aws_availability_zones.available.names["${count.index}"]

    tags = {
        Name = "${var.project}-${var.environment}-public-${substr(data.aws_availability_zones.available.names["${count.index}"],-2, 2)}"
    }
}

resource "aws_subnet" "private" {
    count = local.azs
    vpc_id = aws_vpc.vpc.id 
    map_public_ip_on_launch = false 
    cidr_block = cidrsubnet(var.vpc_cidr, 4, "${sum([count.index, local.azs])}")
    availability_zone = data.aws_availability_zones.available.names["${count.index}"]

    tags = {
        Name = "${var.project}-${var.environment}-private-${substr(data.aws_availability_zones.available.names["${count.index}"],-2, 2)}"
    }
  
}


resource "aws_eip" "eip" {
    count = var.enable_nat_gateway ? 1 : 0
    vpc = true 
    
    depends_on = [
      aws_internet_gateway.igw
    ]

    tags = {
      "Name" = "${var.project}-${var.environment}"
    }

}

resource "aws_nat_gateway" "nat" {
    count = var.enable_nat_gateway ? 1 : 0
    allocation_id = aws_eip.eip[0].id 
    subnet_id = aws_subnet.public[1].id 

    tags = {
      "Name" = "${var.project}-${var.environment}"
    }
  
}

resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      "Name" = "${var.project}-${var.environment}-public"
    }
  
}

resource "aws_route_table" "private_route" {
    count = var.enable_nat_gateway ? 1 : 0
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat[0].id 
    }  

    tags = {
      "Name" = "${var.project}-${var.environment}-private"
    }
}

resource "aws_route_table_association" "public" {
    count = local.azs
    subnet_id = aws_subnet.public["${count.index}"].id
    route_table_id = aws_route_table.public_route.id
}


resource "aws_route_table_association" "private" {
    count = var.enable_nat_gateway ? local.azs : 0
    subnet_id = aws_subnet.private["${count.index}"].id
    route_table_id = aws_route_table.private_route[0].id 
}
