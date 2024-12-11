resource "aws_db_subnet_group" "aurora" {
  name       = "${var.cluster_name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.cluster_name}-subnet-group"
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_pg" {
  name   = "${var.cluster_name}-pg"
  family = var.engine_family

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = var.cluster_name
  engine                  = var.engine
  engine_version          = var.engine_version
  master_username         = var.master_username
  master_password         = var.master_password
  database_name           = var.database_name
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_pg.name
  storage_encrypted       = true
  kms_key_id              = var.kms_key_id
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  deletion_protection     = var.deletion_protection
  enable_http_endpoint    = false
  vpc_security_group_ids  = [aws_security_group.db.id]

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_security_group" "db" {
  name_prefix = "${var.cluster_name}-db-"
  description = "Aurora security group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                = var.instance_count
  identifier           = "${var.cluster_name}-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.aurora.id
  instance_class       = var.instance_class
  engine               = aws_rds_cluster.aurora.engine
  engine_version       = aws_rds_cluster.aurora.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.aurora.name
}
