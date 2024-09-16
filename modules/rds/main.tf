# KMS key for RDS encryption
resource "aws_kms_key" "rds" {
  description             = "${var.environment} RDS encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "${var.environment}-rds-encryption"
  }
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${var.environment}-rds-encryption"
  target_key_id = aws_kms_key.rds.key_id
}

# Security group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.identifier}-rds"
  description = "Security group for ${var.identifier} RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  tags = {
    Name = "${var.identifier}-rds"
  }
}

# Subnet group for RDS
resource "aws_db_subnet_group" "main" {
  name        = var.identifier
  description = "Subnet group for ${var.identifier} RDS instance"
  subnet_ids  = var.subnet_ids

  tags = {
    Name = var.identifier
  }
}

# Random password generation for RDS
resource "random_password" "master" {
  length  = 16
  special = true
  # Exclude characters that might cause issues
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Store the password in Secrets Manager
resource "aws_secretsmanager_secret" "rds_password" {
  name        = "${var.identifier}-master-password"
  description = "Master password for ${var.identifier} RDS instance"
  kms_key_id  = aws_kms_key.rds.arn
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = aws_secretsmanager_secret.rds_password.id
  secret_string = jsonencode({
    username = var.master_username
    password = random_password.master.result
  })
}

# RDS instance
resource "aws_db_instance" "main" {
  identifier = var.identifier

  engine         = "postgres"
  engine_version = var.engine_version

  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name  = var.database_name
  username = var.master_username
  password = random_password.master.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az               = var.multi_az
  publicly_accessible    = false

  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  storage_encrypted = true
  kms_key_id       = aws_kms_key.rds.arn

  auto_minor_version_upgrade = true
  allow_major_version_upgrade = false

  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.identifier}-final-snapshot"

  performance_insights_enabled = true
  performance_insights_retention_period = 7
  performance_insights_kms_key_id = aws_kms_key.rds.arn

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = {
    Name        = var.identifier
    Environment = var.environment
  }
}
