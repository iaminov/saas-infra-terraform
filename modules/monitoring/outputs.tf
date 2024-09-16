output "container_insights_log_group_name" {
  description = "Name of the CloudWatch Log Group for Container Insights"
  value       = aws_cloudwatch_log_group.container_insights.name
}

output "rds_enhanced_monitoring_role_arn" {
  description = "ARN of the IAM role used for RDS enhanced monitoring"
  value       = aws_iam_role.rds_enhanced_monitoring.arn
}

output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "eks_alarms" {
  description = "Map of EKS-related CloudWatch alarms"
  value = {
    node_count = aws_cloudwatch_metric_alarm.eks_node_count.arn
    pod_pending = aws_cloudwatch_metric_alarm.eks_pod_pending.arn
  }
}

output "rds_alarms" {
  description = "Map of RDS-related CloudWatch alarms"
  value = {
    cpu = aws_cloudwatch_metric_alarm.rds_cpu.arn
    memory = aws_cloudwatch_metric_alarm.rds_memory.arn
    storage = aws_cloudwatch_metric_alarm.rds_storage.arn
  }
}
