
provider "aws" {
    region = var.aws_region
}

# VPC
resource "aws_vpc" "terra_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "terra_vpc"
    }
}

# Private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.terra_vpc.id
    cidr_block = var.private_cidr_block
    availability_zone = var.private_subnet_az
    map_public_ip_on_launch = false
    tags = {
        Name = "Private-eu-central-1a"
    }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.terra_vpc.id
    cidr_block = var.public_cidr_block
    availability_zone = var.public_subnet_az
    map_public_ip_on_launch = true
    tags = {
        Name = "Public-eu-central-1b"
    }
}

# Internet gateway for Terra VPC
resource "aws_internet_gateway" "igw-terra-vpc" {
    vpc_id = aws_vpc.terra_vpc.id
    tags = {
        Name = "IGW for terra vpc"
    }
}

# Private route table
resource "aws_route_table" "private-rt-terra" {
    vpc_id = aws_vpc.terra_vpc.id
    tags = {
        Name = "private-rt-terra"
    }
}

# Public route table
resource "aws_route_table" "public-rt-terra" {
    vpc_id = aws_vpc.terra_vpc.id
    tags = {
        Name = "public-rt-terra"
    }
}

# Associate public RT table with public subnet
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public-rt-terra.id
}

# Default route - traffic directed to IGW
resource "aws_route" "default_route" {
    route_table_id = aws_route_table.public-rt-terra.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-terra-vpc.id
}


# Security Group
resource "aws_security_group" "frontend-sg" {
    name = "frontend-sg"
    description = "Allow access from public internet/ ssh/ https/ icmp"
    vpc_id = aws_vpc.terra_vpc.id
    tags = {
        Name = "frontend-sg"
    }
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id = aws_security_group.frontend-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = "22"
    ip_protocol = "tcp"
    to_port = "22"
}

# Egress rule missing - to be added

# EC2 instance - reachable from internet
resource "aws_instance" "web_server" {
    ami = "ami-015cbce10f839bd0c"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
    # If you are creating Instances in a VPC, use (terraform aws documentation):
    vpc_security_group_ids = [aws_security_group.frontend-sg.id]

    tags = {
        Name = "web_server"
    }
}



















