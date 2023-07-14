variable "org_code" {}

variable "vpc_id" {}

variable "org_base_domain" {}

variable "assume_role_name" {

}

variable "assume_role_service" {

}

variable "iam_role_policy_action" {
  default = ["ec2:Describe*"]
  type    = list(string)
}

variable "bastion_cidr" {
  default = ["0.0.0.0/0"]
  type    = list(string)
}

variable "toolingsite_a_record" {}

variable "wpsite_a_record" {}

variable "alias_name" {}

variable "alias_zone_id" {}

variable "tags" {}