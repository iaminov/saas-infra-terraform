provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  environment = var.environment
  region     = var.aws_region
}

module "networking" {
  source = "../../modules/networking"

  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  private_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnet_cidrs  = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  environment         = var.environment
}

# SNS topic for alarms
resource "aws_sns_topic" "alerts" {
  name = "${local.environment}-infrastructure-alerts"
}

module "rds" {
  source = "../../modules/rds"

  environment            = local.environment
  identifier            = "${local.environment}-main"
  vpc_id                = module.networking.vpc_id
  subnet_ids            = module.networking.private_subnet_ids
  allowed_security_groups = [module.eks.cluster_security_group_id]

  database_name = "saasapp"
  multi_az     = true  # High availability for production

  instance_class        = "db.t3.large"  # Larger instance for production
  allocated_storage     = 50
  max_allocated_storage = 200

  backup_retention_period = 30  # Longer retention for production
}

module "monitoring" {
  source = "../../modules/monitoring"

  environment    = local.environment
  aws_region     = local.region
  cluster_name   = module.eks.cluster_id
  db_instance_id = module.rds.instance_id
  alarm_actions  = [aws_sns_topic.alerts.arn]
  min_node_count = 3  # Higher minimum node count for production
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = var.cluster_name
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn   = module.iam.node_role_arn
  subnet_ids      = module.networking.private_subnet_ids
  vpc_id          = module.networking.vpc_id

  kubernetes_version  = "1.27"
  node_instance_types = ["t3.large"]  # Larger instances for production
  node_desired_size  = 3
  node_min_size     = 3
  node_max_size     = 6
}

module "iam" {
  source = "../../modules/iam"

  environment    = var.environment
  cluster_name   = var.cluster_name
  aws_account_id = data.aws_caller_identity.current.account_id
}
