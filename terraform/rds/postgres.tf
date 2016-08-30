resource "aws_db_instance" "database" {
  identifier              = "${var.instance_identifier}"
  allocated_storage       = "${var.allocated_storage}"
  storage_type            = "${var.storage_type}"
  engine                  = "postgres"
  instance_class          = "${var.instance_class}"
  name                    = "${var.master_database}"
  username                = "${var.root_username}"
  password                = "${var.root_password}"
  port                    = 5432
  publicly_accessible     = false
  vpc_security_group_ids  = ["${aws_security_group.rds.id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.rds.name}"
  multi_az                = true
  backup_retention_period = 7
  backup_window           = "08:17-08:47"
  maintenance_window      = "mon:05:06-mon:05:36"

  tags {
    Name = "${var.service_name} RDS"
  }
}
