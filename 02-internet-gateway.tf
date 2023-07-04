# Create internet gateway
resource "aws_internet_gateway" "ig-punltd" {
  vpc_id = aws_vpc.part-unltd-vpc.id
  tags = merge(
    var.tags, {
        Name = "${var.org_code}-igw"
    }
  )
}