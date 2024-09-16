variable "environment" {
  description = "Environment name (e.g. staging, production)"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_provider_url" {
  description = "OpenID Connect provider URL for EKS cluster"
  type        = string
  default     = ""
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}
