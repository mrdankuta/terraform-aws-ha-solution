# Create elastic ip
resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = merge(
    var.tags, {
      Name = "${var.org_code}-eip"
    }
  )
}

# Create NAT Gateway & associate to EIP
resource "aws_nat_gateway" "nat-gw" {
  subnet_id     = aws_subnet.public-subnet[0].id
  allocation_id = aws_eip.eip.id
  depends_on    = [aws_internet_gateway.igw]
  tags = merge(
    var.tags, {
      Name = "${var.org_code}-nat-gw"
    }
  )
}