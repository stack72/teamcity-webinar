resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "${var.service_name} RDS Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.service_name} RDS Security Group"
  }
}

resource "aws_db_subnet_group" "rds" {
  name        = "${lower(var.service_name)}-subnet-group"
  description = "${var.service_name} Subnet Group"
  subnet_ids  = ["${var.private_subnet_ids}"]

  tags {
    Name = "${var.service_name} RDS Subnet Group"
  }
}
