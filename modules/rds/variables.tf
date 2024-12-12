variable "cluster_name" {
  description = "Aurora cluster name"
  type        = string
}

variable "engine" {
  description = "Aurora engine"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "Aurora engine version"
  type        = string
  default     = "15.3"
}

variable "engine_family" {
  description = "Parameter group family"
  type        = string
  default     = "aurora-postgresql15"
}

variable "master_username" {
  description = "Master username"
  type        = string
}

variable "master_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "app"
}

variable "kms_key_id" {
  description = "KMS key for encryption"
  type        = string
}

variable "backup_retention_period" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "07:00-09:00"
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "instance_count" {
  description = "Number of cluster instances"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "DB instance class"
  type        = string
  default     = "db.r6g.large"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
