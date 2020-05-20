resource "aws_elasticache_replication_group" "main" {
  replication_group_id          = var.replication_group_id
  replication_group_description = "Replication group for ${var.replication_group_id}} (Cluster mode disabled)"
  number_cache_clusters         = 1
  node_type                     = var.node_type
  automatic_failover_enabled    = false
  auto_minor_version_upgrade    = true
  engine                        = "redis"
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  auth_token                    = var.auth_token
  parameter_group_name          = aws_elasticache_parameter_group.main.name
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.main.name
  security_group_ids            = [aws_security_group.main.id]
  maintenance_window            = var.maintenance_window
  snapshot_window               = var.snapshot_window
  apply_immediately             = true
}

resource "aws_elasticache_parameter_group" "main" {
  name   = var.replication_group_id
  family = "redis5.0"

  parameter {
    name  = "cluster-enabled"
    value = "no"
  }

  parameter {
    name  = "timeout"
    value = 60
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = var.replication_group_id
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "main" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8539
    to_port         = 8559
    protocol        = "tcp"
    security_groups = var.security_group_ids_to_allow
  }

  egress {
    from_port   = 8539
    to_port     = 8559
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
