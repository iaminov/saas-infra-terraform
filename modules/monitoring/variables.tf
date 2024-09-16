variable "environment" {
  description = "Environment name for tagging and resource naming"
  type        = string
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "db_instance_id" {
  description = "Identifier of the RDS instance"
  type        = string
}

variable "min_node_count" {
  description = "Minimum number of nodes that should be running"
  type        = number
  default     = 2
}

variable "alarm_actions" {
  description = "List of ARNs to notify when alarm triggers (e.g., SNS topics)"
  type        = list(string)
}
