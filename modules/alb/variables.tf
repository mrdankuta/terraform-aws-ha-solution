variable "public_alb_security_groups" {}

variable "internal_alb_security_groups" {}

variable "public_alb_subnets" {}

variable "internal_alb_subnets" {}

variable "org_code" {}

variable "public_alb_ip_address_type" {
  default = "ipv4"
}

variable "public_alb_load_balancer_type" {
  default = "application"
}

variable "internal_alb_ip_address_type" {
  default = "ipv4"
}

variable "internal_alb_load_balancer_type" {
  default = "application"
}

variable "vpc_id" {}

variable "org_base_domain" {}

variable "tags" {}



