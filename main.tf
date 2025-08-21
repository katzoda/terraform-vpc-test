
provider "aws" {
    region = var.aws_region
}

# VPC
resource "aws_vpc" "test_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "test_vpc"
    }
}

