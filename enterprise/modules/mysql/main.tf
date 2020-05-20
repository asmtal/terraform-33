resource "aws_db_instance" "main" {
  allocated_storage       = var.allocated_storage
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = var.instance_class
  username                = var.username
  password                = var.password
  port                    = 3306
  publicly_accessible     = false
  security_group_names    = []
  vpc_security_group_ids  = [aws_security_group.main.id]
  db_subnet_group_name    = aws_db_subnet_group.main.id
  parameter_group_name    = aws_db_parameter_group.main.id
  multi_az                = true
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  skip_final_snapshot     = true
}

resource "aws_db_subnet_group" "main" {
  subnet_ids = var.subnet_ids
}

resource "aws_db_parameter_group" "main" {
  family = "mysql5.7"

  parameter {
    name         = "max_allowed_packet"
    value        = "32000000"
    apply_method = "immediate"
  }
}

resource "aws_security_group" "main" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.security_group_ids_to_allow
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
