# Container Insights for EKS
resource "aws_cloudwatch_log_group" "container_insights" {
  name              = "/aws/containerinsights/${var.cluster_name}/performance"
  retention_in_days = 30

  tags = {
    Name        = "${var.cluster_name}-container-insights"
    Environment = var.environment
  }
}

# Enhanced monitoring IAM role for RDS
resource "aws_iam_role" "rds_enhanced_monitoring" {
  name = "${var.environment}-rds-enhanced-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.environment}-infrastructure"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EKS", "cluster_failed_node_count", "ClusterName", var.cluster_name],
            [".", "cluster_node_count", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "EKS Node Count"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance_id],
            [".", "FreeableMemory", ".", "."],
            [".", "FreeStorageSpace", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "RDS Metrics"
        }
      }
    ]
  })
}

# CloudWatch Alarms for EKS
resource "aws_cloudwatch_metric_alarm" "eks_node_count" {
  alarm_name          = "${var.cluster_name}-node-count"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "cluster_node_count"
  namespace          = "AWS/EKS"
  period             = "300"
  statistic          = "Average"
  threshold          = var.min_node_count
  alarm_description  = "This metric monitors EKS cluster node count"
  alarm_actions      = var.alarm_actions

  dimensions = {
    ClusterName = var.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eks_pod_pending" {
  alarm_name          = "${var.cluster_name}-pending-pods"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "pod_pending_count"
  namespace          = "ContainerInsights"
  period             = "300"
  statistic          = "Average"
  threshold          = 0
  alarm_description  = "This metric monitors pending pods in EKS cluster"
  alarm_actions      = var.alarm_actions

  dimensions = {
    ClusterName = var.cluster_name
  }
}

# CloudWatch Alarms for RDS
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.db_instance_id}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "3"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/RDS"
  period             = "300"
  statistic          = "Average"
  threshold          = 80
  alarm_description  = "This metric monitors RDS CPU utilization"
  alarm_actions      = var.alarm_actions

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_memory" {
  alarm_name          = "${var.db_instance_id}-low-memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  metric_name        = "FreeableMemory"
  namespace          = "AWS/RDS"
  period             = "300"
  statistic          = "Average"
  threshold          = 1000000000  # 1GB in bytes
  alarm_description  = "This metric monitors RDS freeable memory"
  alarm_actions      = var.alarm_actions

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_storage" {
  alarm_name          = "${var.db_instance_id}-low-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  metric_name        = "FreeStorageSpace"
  namespace          = "AWS/RDS"
  period             = "300"
  statistic          = "Average"
  threshold          = 5000000000  # 5GB in bytes
  alarm_description  = "This metric monitors RDS free storage space"
  alarm_actions      = var.alarm_actions

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}
