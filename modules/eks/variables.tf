variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role that provides permissions for the Kubernetes control plane"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role that provides permissions for the EKS Node Group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the nodes/node groups will be provisioned"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be provisioned"
  type        = string
}

variable "kubernetes_version" {
  description = "Desired Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_instance_types" {
  description = "List of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = ["t3.medium"]
}
