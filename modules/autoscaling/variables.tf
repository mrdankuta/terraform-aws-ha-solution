variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "bastion_security_grp_ids" {}

variable "bastion_vpc_zone_id" {}

variable "iam_instance_profile_id" {}

variable "keypair" {}

variable "nginx_proxy_instance_type" {
  default = "t2.micro"
}

variable "nginx_proxy_security_grp_ids" {}

variable "nginx_proxy_vpc_zone_id" {}

variable "wpsite_instance_type" {
  default = "t2.micro"
}

variable "wpsite_security_grp_ids" {}

variable "wpsite_vpc_zone_id" {}

variable "wpsite_target_grp_arn" {}

variable "tooling_instance_type" {
  default = "t2.micro"
}

variable "tooling_security_grp_ids" {}

variable "tooling_vpc_zone_id" {}

variable "tooling_target_grp_arn" {}

variable "az_list_names" {}

variable "tags" {}