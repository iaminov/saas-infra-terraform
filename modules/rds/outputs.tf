output "instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "instance_address" {
  description = "Address of the RDS instance"
  value       = aws_db_instance.main.address
}

output "instance_endpoint" {
  description = "Connection endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "subnet_group_id" {
  description = "ID of the RDS subnet group"
  value       = aws_db_subnet_group.main.id
}

output "master_secret_arn" {
  description = "ARN of the Secrets Manager secret containing master credentials"
  value       = aws_secretsmanager_secret.rds_password.arn
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for RDS encryption"
  value       = aws_kms_key.rds.arn
}
