provider "aws" {
  region = var.aws_region
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

# Local variables
locals {
  database_name = var.database_name
  name_prefix   = var.project_name
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# API Gateway
module "api_gateway" {
  source               = "./modules/api_gateway"
  name_prefix          = local.name_prefix
  cognito_user_pool_id = module.cognito.user_pool_id
  ecs_alb_dns_name     = module.ecs.alb_dns_name
  ecs_target_group_arn = module.ecs.target_group_arn
  lambda_router_arn    = module.lambda.router_function_arn
  waf_acl_arn          = module.security.waf_acl_arn
  tags                 = local.common_tags
  environment          = var.environment
  aws_region           = var.aws_region
}


# VPC and Networking
module "vpc" {
  source             = "./modules/vpc/"
  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = data.aws_availability_zones.available.names
  tags               = local.common_tags
  aws_region         = var.aws_region
}

# Security
module "security" {
  source      = "./modules/security"
  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  tags        = local.common_tags
  aws_region  = var.aws_region
}

# Cognito
module "cognito" {
  source      = "./modules/cognito"
  name_prefix = local.name_prefix
  tags        = local.common_tags
  aws_region  = var.aws_region

}

# S3 Storage
module "s3" {
  source      = "./modules/s3"
  name_prefix = local.name_prefix
  tags        = local.common_tags
  aws_region  = var.aws_region
}

# Database
module "database" {
  source                     = "./modules/database"
  database_name              = local.database_name
  name_prefix                = local.name_prefix
  ecs_sg_id                  = module.security.ecs_sg_id
  enable_deletion_protection = var.enable_deletion_protection
  private_subnet_ids         = module.vpc.private_subnet_ids
  backup_retention_period    = var.backup_retention_period
  vpc_id                     = module.vpc.vpc_id
  instance_class             = var.instance_class
  db_master_password         = var.db_master_password
  lambda_sg_id               = module.security.lambda_sg_id
  db_master_username         = var.db_master_username
  skip_final_snapshot        = var.skip_final_snapshot
  tags                       = local.common_tags
  aws_region                 = var.aws_region
}


# ECR
module "ecr" {
  source      = "./modules/ecr"
  name_prefix = local.name_prefix
  tags        = local.common_tags
  aws_region  = var.aws_region
}

# ECS
module "ecs" {
  source             = "./modules/ecs"
  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_ids = [module.security.ecs_sg_id]
  ecr_repository_url = module.ecr.banking_api_repository_url
  aurora_endpoint    = module.database.aurora_cluster_endpoint
  tags               = local.common_tags
  aws_region         = var.aws_region
}

# Lambda
module "lambda" {
  name_prefix         = local.name_prefix
  source              = "./modules/lambda"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_ids  = [module.security.lambda_sg_id]
  sqs_queue_url       = module.messaging.sqs_queue_url
  s3_bucket_name      = module.s3.data_bucket_name
  aurora_endpoint     = module.database.aurora_cluster_endpoint
  dynamodb_table_name = module.database.dynamodb_table_name
  tags                = local.common_tags
  lambda_policy_arn   = module.lambda.lambda_policy_arn
  aws_region          = var.aws_region

}

# Messaging
module "messaging" {
  source      = "./modules/messaging"
  name_prefix = local.name_prefix
  tags        = local.common_tags
  aws_region  = var.aws_region
}

# Analytics
module "analytics" {
  source              = "./modules/analytics"
  name_prefix         = local.name_prefix
  s3_bucket_name      = module.s3.data_bucket_name
  aurora_endpoint     = module.database.aurora_cluster_endpoint
  dynamodb_table_name = module.database.dynamodb_table_name
  db_master_username  = var.db_master_username
  db_master_password  = var.db_master_password
  tags                = local.common_tags
  aws_region          = var.aws_region
}

# AI/ML
module "ai_ml" {
  source             = "./modules/ai_ml"
  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_ids = [module.security.sagemaker_sg_id]
  ecr_repository_url = module.ecr.langflow_repository_url
  s3_bucket_name     = module.s3.data_bucket_name
  sns_topic_arn      = module.messaging.sns_topic_arn
  tags               = local.common_tags
  aws_region         = var.aws_region
}

# Monitoring
module "monitoring" {
  source      = "./modules/monitoring"
  name_prefix = local.name_prefix
  tags        = local.common_tags
  aws_region  = var.aws_region
}
