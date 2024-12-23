output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = module.eks_cluster.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS cluster"
  value       = module.eks_cluster.cluster_endpoint
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.networking.private_subnet_ids
}
