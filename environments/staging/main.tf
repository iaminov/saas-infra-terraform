provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../modules/networking"

  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
  environment = var.environment
}

# SNS topic for alarms
resource "aws_sns_topic" "alerts" {
  name = "${local.environment}-infrastructure-alerts"
}

module "rds" {
  source = "../../modules/rds"

  environment            = local.environment
  identifier             = "${local.environment}-main"
  vpc_id                 = module.networking.vpc_id
  subnet_ids             = module.networking.private_subnet_ids
  allowed_security_groups = [module.eks.cluster_security_group_id]

  database_name = "saasapp"
  multi_az      = false  # Set to true for production
}

module "monitoring" {
  source = "../../modules/monitoring"

  environment    = local.environment
  aws_region     = local.region
  cluster_name   = module.eks.cluster_id
  db_instance_id = module.rds.instance_id
  alarm_actions  = [aws_sns_topic.alerts.arn]
}

module "eks" {
  source = "../../modules/eks"

  cluster_name     = var.cluster_name
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
  subnet_ids       = module.networking.private_subnet_ids
  vpc_id           = module.networking.vpc_id

  kubernetes_version   = "1.27"
  node_instance_types = ["t3.medium"]
  node_desired_size   = 2
  node_min_size       = 1
  node_max_size       = 4
}

module "iam" {
  source = "../../modules/iam"

  environment     = var.environment
  cluster_name    = var.cluster_name
  aws_account_id  = data.aws_caller_identity.current.account_id
}
