# Create the subnet group for the RDS  instance using the private subnet
resource "aws_db_subnet_group" "rds-grp" {
  name       = "rds-grp"
  subnet_ids = var.subnet_ids_list

  tags = merge(
    var.tags,
    {
      Name = "${var.org_code}-rds-grp"
    },
  )
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "rds-db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.${var.db_instance_type}"
  db_name                = var.rds_db_name
  username               = var.rds_dbadmin_username
  password               = var.rds_dbadmin_password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.rds-grp.name
  skip_final_snapshot    = true
  vpc_security_group_ids = var.security_groups_ids
  multi_az               = var.is_multi_az
}


# resource "aws_db_instance" "read_replica" {
#   count               = var.create_read_replica == true ? 1 : 0
#   replicate_source_db = aws_db_instance.rds-db.id
# }