provider "aws" {
  region = var.aws_region
}

module "main" {
  source                     = "../../"
  aws_region                 = var.aws_region
  project_name               = var.project_name
  environment                = var.environment
  vpc_cidr                   = var.vpc_cidr
  db_master_username         = var.db_master_username
  db_master_password         = var.db_master_password
  enable_deletion_protection = var.enable_deletion_protection
  backup_retention_period    = var.backup_retention_period
  instance_class             = var.instance_class
  domain_name                = var.domain_name
  certificate_arn            = var.certificate_arn
}
