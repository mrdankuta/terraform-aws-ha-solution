variable "org_code" {}


variable "subnet_ids_list" {}

variable "db_instance_type" {}

variable "rds_db_name" {}

variable "rds_dbadmin_username" {}

variable "rds_dbadmin_password" {}

variable "security_groups_ids" {}

variable "is_multi_az" {
    default = "true"
}

variable "tags" {}