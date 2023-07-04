# Create Public Route Table
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.part-unltd-vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-punltd.id
  }

  tags = merge(
    var.tags, {
        Name = "${var.org_code}-public-rtb"
    }
  )
}



# Associate Public Route Table with Public layer Subnets
resource "aws_route_table_association" "public_subnets_rtb_assoc" {
    count          = var.layer-subnets-num == null || var.layer-subnets-num <= 0 || var.layer-subnets-num > length(data.aws_availability_zones.az-list.names) - 1 ? length(data.aws_availability_zones.az-list.names) : var.layer-subnets-num
    subnet_id      = aws_subnet.public-subnet-punltd[count.index].id
    route_table_id = aws_route_table.public_rtb.id
}



# Create Private Route Table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.part-unltd-vpc.id

  tags = merge(
    var.tags, {
        Name = "${var.org_code}-private-rtb"
    }
  )
}



# Associate subnets with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  count             = var.layer-subnets-num == null || var.layer-subnets-num <= 0 || var.layer-subnets-num > length(data.aws_availability_zones.az-list.names) - 1 ? length(data.aws_availability_zones.az-list.names) : var.layer-subnets-num
  subnet_id         = aws_subnet.prv-proxy-subnet-punltd[count.index].id
  route_table_id    = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "private_subnet_association_compute" {
  count             = var.layer-subnets-num == null || var.layer-subnets-num <= 0 || var.layer-subnets-num > length(data.aws_availability_zones.az-list.names) - 1 ? length(data.aws_availability_zones.az-list.names) : var.layer-subnets-num
  subnet_id         = aws_subnet.prv-compute-subnet-punltd[count.index].id
  route_table_id    = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "private_subnet_association_data" {
  count             = var.layer-subnets-num == null || var.layer-subnets-num <= 0 || var.layer-subnets-num > length(data.aws_availability_zones.az-list.names) - 1 ? length(data.aws_availability_zones.az-list.names) : var.layer-subnets-num
  subnet_id         = aws_subnet.prv-data-subnet-punltd[count.index].id
  route_table_id    = aws_route_table.private_rtb.id
}