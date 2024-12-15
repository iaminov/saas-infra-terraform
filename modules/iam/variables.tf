variable "tenant" {
  description = "Tenant identifier"
  type        = string
}

variable "trusted_principals" {
  description = "Trusted AWS principals for tenant role"
  type        = list(string)
  default     = []
}

variable "inline_policy_json" {
  description = "Inline policy JSON for tenant role"
  type        = string
  default     = jsonencode({ Version = "2012-10-17", Statement = [] })
}

variable "eks_oidc_url" {
  description = "EKS OIDC issuer URL"
  type        = string
}

variable "oidc_thumbprint" {
  description = "OIDC provider thumbprint"
  type        = string
}

variable "irsa_service_accounts" {
  description = "Allowed service account subjects for IRSA"
  type        = list(string)
  default     = []
}

variable "irsa_role_names" {
  description = "IRSA role names"
  type        = list(string)
  default     = []
}

variable "irsa_inline_policy_json" {
  description = "Inline policy JSON for IRSA roles"
  type        = string
  default     = jsonencode({ Version = "2012-10-17", Statement = [] })
}
