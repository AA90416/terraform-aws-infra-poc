# modules/vpc/main.tf
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "public" {
  count         = length(var.availability_zones)
  cidr_block    = cidrsubnet(var.vpc_cidr_block, 8, count.index + 1)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count         = length(var.availability_zones)
  cidr_block    = cidrsubnet(var.vpc_cidr_block, 8, count.index + 11)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}