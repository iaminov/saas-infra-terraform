output "grafana_release_name" {
  description = "Grafana release name"
  value       = helm_release.grafana.name
}
