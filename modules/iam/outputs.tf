output "tenant_role_arn" {
  description = "Tenant role ARN"
  value       = aws_iam_role.tenant_role.arn
}

output "irsa_role_arns" {
  description = "IRSA role ARNs"
  value       = aws_iam_role.irsa_role[*].arn
}
