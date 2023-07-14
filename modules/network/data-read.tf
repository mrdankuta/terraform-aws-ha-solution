# Get list of availability zones
data "aws_availability_zones" "az-list" {
  state = "available"
}