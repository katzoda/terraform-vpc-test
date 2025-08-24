
variable "aws_region" {
    default = "eu-central-1"
}

variable "vpc_cidr" {
    default = "10.1.0.0/16" 
}

variable "private_cidr_block" {
    description = "CIDR for a private subnet"
    default = "10.1.0.0/24"
}

variable "public_cidr_block" {
    description = "CIDR for a public subnet"
    default = "10.2.0.0/24"
}

variable "private_subnet_az" {
    description = "AZ for private subnets"
    default = "eu-central-1a"
}

variable "public_subnet_az" {
    description = "AZ for private subnets"
    default = "eu-central-1b"
}

