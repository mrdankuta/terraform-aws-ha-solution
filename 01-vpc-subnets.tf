# Create VPC
resource "aws_vpc" "part-unltd-vpc" {
  cidr_block                      = var.vpc_cidr
  enable_dns_support              = var.enable_dns_support
  enable_dns_hostnames            = var.enable_dns_hostnames
  enable_classiclink              = var.enable_classiclink
  enable_classiclink_dns_support  = var.enable_classiclink_dns_support
  tags = merge(
    var.tags, {
      Name = "${var.org_code}-vpc"
    }
  )
}


# Create public layer subnets
resource "aws_subnet" "public-subnet-punltd" {
  vpc_id                  = aws_vpc.part-unltd-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index + (var.layer-subnets-num*1))
  map_public_ip_on_launch = true
  count                   = var.layer-subnets-num == null || var.layer-subnets-num <= 0 || var.layer-subnets-num > length(data.aws_availability_zones.az-list.names) - 1 ? length(data.aws_availability_zones.az-list.names) : var.layer-subnets-num
  availability_zone       = data.aws_availability_zones.az-list.names[count.index]
  tags = merge(
    var.tags, {
      Name = "public-subnet-${var.org_code}-${data.aws_availability_zones.az-list.names[count.index]}"
    }
  )
}


# Create proxy layer subnets
resource "aws_subnet" "prv-proxy-subnet-punltd" {
  vpc_id                  = aws_vpc.part-unltd-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index + (var.layer-subnets-num*2))
  map_public_ip_on_launch = true
  count                   = var.layer-subnets-num == null || var.layer-subnets-num <= 0 || var.layer-subnets-num > length(data.aws_availability_zones.az-list.names) - 1 ? length(data.aws_availability_zones.az-list.names) : var.layer-subnets-num
  availability_zone       = data.aws_availability_zones.az-list.names[count.index]
  tags = merge(
    var.tags, {
      Name = "proxy-subnet-${var.org_code}-${data.aws_availability_zones.az-list.names[count.index]}"
    }
  )
}


# Create compute layer subnets
resource "aws_subnet" "prv-compute-subnet-punltd" {
  vpc_id                  = aws_vpc.part-unltd-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index + (var.layer-subnets-num*3))
  map_public_ip_on_launch = true
  count                   = var.layer-subnets-num == null || var.layer-subnets-num <= 0 || var.layer-subnets-num > length(data.aws_availability_zones.az-list.names) - 1 ? length(data.aws_availability_zones.az-list.names) : var.layer-subnets-num
  availability_zone       = data.aws_availability_zones.az-list.names[count.index]
  tags = merge(
    var.tags, {
      Name = "compute-subnet-${var.org_code}-${data.aws_availability_zones.az-list.names[count.index]}"
    }
  )
}


# Create data layer subnets
resource "aws_subnet" "prv-data-subnet-punltd" {
  vpc_id                  = aws_vpc.part-unltd-vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index + (var.layer-subnets-num*4))
  map_public_ip_on_launch = true
  count                   = var.layer-subnets-num == null || var.layer-subnets-num <= 0 || var.layer-subnets-num > length(data.aws_availability_zones.az-list.names) - 1 ? length(data.aws_availability_zones.az-list.names) : var.layer-subnets-num
  availability_zone       = data.aws_availability_zones.az-list.names[count.index]
  tags = merge(
    var.tags, {
      Name = "data-subnet-${var.org_code}-${data.aws_availability_zones.az-list.names[count.index]}"
    }
  )
}