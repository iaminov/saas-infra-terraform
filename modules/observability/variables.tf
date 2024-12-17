variable "namespace" {
  description = "Namespace for observability stack"
  type        = string
  default     = "observability"
}

variable "kps_chart_version" {
  description = "kube-prometheus-stack chart version"
  type        = string
  default     = "58.3.2"
}

variable "loki_chart_version" {
  description = "Loki chart version"
  type        = string
  default     = "5.41.4"
}

variable "grafana_chart_version" {
  description = "Grafana chart version"
  type        = string
  default     = "8.5.7"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}
