# Create the subnet group for the RDS  instance using the private subnet
resource "aws_db_subnet_group" "partsunltd-rds-grp" {
  name       = "partsunltd-rds-grp"
  subnet_ids = [aws_subnet.prv-data-subnet-punltd[0].id, aws_subnet.prv-data-subnet-punltd[1].id]

 tags = merge(
    var.tags,
    {
      Name = "${var.org_code}-rds-grp"
    },
  )
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "partsunltd-rds-db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = var.rds_db_name
  username               = var.rds_dbadmin_username
  password               = var.rds_dbadmin_password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.partsunltd-rds-grp.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.datalayer-sg.id]
  multi_az               = "true"
}