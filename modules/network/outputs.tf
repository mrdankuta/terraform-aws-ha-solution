output "network-vpc" {
  value = aws_vpc.network-vpc
}

output "public_subnets" {
  value = aws_subnet.public-subnet
}

output "proxy_subnets" {
  value = aws_subnet.prv-proxy-subnet
}

output "compute_subnets" {
  value = aws_subnet.prv-compute-subnet
}

output "data_subnets" {
  value = aws_subnet.prv-data-subnet
}

output "az_list_names" {
  value = data.aws_availability_zones.az-list.names
}