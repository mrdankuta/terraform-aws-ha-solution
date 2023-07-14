variable "org_code" {}
variable "region" {}

variable "vpc_cidr" {}

variable "enable_dns_support" {}

variable "enable_dns_hostnames" {}

variable "enable_classiclink" {}

variable "enable_classiclink_dns_support" {}

variable "layer-subnets-num" {}

variable "tags" {
  default = {}
  type = map(string)
}

variable "org_base_domain" {}

variable "aws_account_no" {}

variable "aws_account_user" {}

variable "rds_db_name" {}

variable "rds_dbadmin_username" {}

variable "rds_dbadmin_password" {}

variable "db_instance_type" {}

variable "state_s3_bucket" {}

variable "assume_role_name" {}

variable "assume_role_service" {}

# variable "iam_role_policy_name" {}

variable "iam_role_policy_action" {
    default = ["ec2:Describe*"]
    type = list(string)
}

variable "bastion_cidr" {
    default = ["0.0.0.0/0"]
    type = list(string)
}

variable "toolingsite_a_record" {}

variable "wpsite_a_record" {}

variable "bastion_instance_type" {}

variable "nginx_proxy_instance_type" {}

variable "wpsite_instance_type" {}

variable "tooling_instance_type" {}

variable "keypair" {}

variable "wpsite_root_path" {
  default = "/wpsite"
}

variable "tooling_root_path" {
  default = "/tooling"
}