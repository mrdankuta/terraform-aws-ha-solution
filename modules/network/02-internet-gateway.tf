# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.network-vpc.id
  tags = merge(
    var.tags, {
        Name = "${var.org_code}-igw"
    }
  )
}