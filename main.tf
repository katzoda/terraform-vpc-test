
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
    map_publip_ip_on_launch = false
    tags = {
        Name = "Private-eu-central-1a"
    }
}

