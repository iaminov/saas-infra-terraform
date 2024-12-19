variable "project" {
  description = "Project name"
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "buildspec" {
  description = "CodeBuild buildspec"
  type        = string
}

variable "codebuild_service_role_arn" {
  description = "CodeBuild service role ARN"
  type        = string
}

variable "codepipeline_role_arn" {
  description = "CodePipeline role ARN"
  type        = string
}

variable "artifact_bucket" {
  description = "S3 bucket for artifacts"
  type        = string
}

variable "github_owner" {
  description = "GitHub owner"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
  default     = "main"
}

variable "github_oauth_token" {
  description = "GitHub OAuth token"
  type        = string
  sensitive   = true
}
