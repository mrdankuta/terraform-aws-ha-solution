variable "org_code" {
  default = "punltd"
}
variable "region" {
      default = "eu-central-1"
}

variable "vpc_cidr" {
    default = "172.16.0.0/16"
}

variable "enable_dns_support" {
    default = "true"
}

variable "enable_dns_hostnames" {
    default ="true" 
}

variable "enable_classiclink" {
    default = "false"
}

variable "enable_classiclink_dns_support" {
    default = "false"
}

variable "layer-subnets-num" {
    default = 2
}

variable "tags" {
  default = {}
  type = map(string)
  description = "taggin for all resources"
}

variable "org_base_domain" {
    default = "partsunltd.soladaniel.com"
}