# Create elastic ip
resource "aws_eip" "eip-punltd" {
  vpc           = true
  depends_on    = [ aws_internet_gateway.ig-punltd ]
  tags          = merge(
    var.tags, {
        Name = "${var.org_code}-eip"
    }
  )
}

# Create NAT Gateway & associate to EIP
resource "aws_nat_gateway" "nat-gw-punltd" {
  subnet_id = aws_subnet.public-subnet-punltd[0].id
  allocation_id = aws_eip.eip-punltd.id
  depends_on = [ aws_internet_gateway.ig-punltd ]
  tags = merge(
    var.tags, {
        Name = "${var.org_code}-nat-gw"
    }
  )
}