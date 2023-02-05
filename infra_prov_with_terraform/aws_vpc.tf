# VPC settings

resource "aws_vpc" "server_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
      Name = "server_vpc"
      }
}


# Internet Gateway

  resource "aws_internet_gateway" "server_internet_gateway" {
    vpc_id = aws_vpc.server_vpc.id
    tags ={
        Name = "server_internet_gateway"
    }
  }


  # Public Route Table

  resource "aws_route_table" "server-route-table-public" {
    vpc_id = aws_vpc.server_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.server_internet_gateway.id
    }

    tags = {
        Name = "server-route-table-public"
    }
  }

# Associate public subnet 1 with public route table

resource "aws_route_table_association" "server-public-subnet1-association" {
    subnet_id      = aws_subnet.server-public-subnet1.id
    route_table_id = aws_route_table.server-route-table-public.id
}


# Associate public subnet 2 with public route table

resource "aws_route_table_association" "server-public-subnet2-association" {
    subnet_id      = aws_subnet.server-public-subnet2.id
    route_table_id = aws_route_table.server-route-table-public.id
}




# Public Subnet-1

resource "aws_subnet" "server-public-subnet1" {
    vpc_id                  = aws_vpc.server_vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"
    tags = {
        Name = "server-public-subnet1"
    }
}

# Public Subnet-2

resource "aws_subnet" "server-public-subnet2" {
    vpc_id                  = aws_vpc.server_vpc.id
    cidr_block              = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1b"
    tags = {
        Name = "server-public-subnet2"
    }
}

# Network ACL

resource "aws_network_acl" "server-network-acl" {
    vpc_id    = aws_vpc.server_vpc.id
    subnet_ids = [aws_subnet.server-public-subnet1.id, aws_subnet.server-public-subnet2.id]

 ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

