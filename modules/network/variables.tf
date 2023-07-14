variable "org_code" {}

variable "vpc_cidr" {}

variable "enable_dns_support" {
    default = "true" 
}

variable "enable_dns_hostnames" {
    default = "true" 
}

variable "enable_classiclink" {
    default = "false"
}

variable "enable_classiclink_dns_support" {
    default = "false"
}

variable "layer-subnets-num" {}

variable "tags" {
  default = {}
  type = map(string)
}