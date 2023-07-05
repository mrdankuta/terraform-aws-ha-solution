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

variable "myip" {}

variable "aws_account_no" {}

variable "aws_account_user" {}

variable "rds_db_name" {}

variable "rds_dbadmin_username" {}

variable "rds_dbadmin_password" {}

