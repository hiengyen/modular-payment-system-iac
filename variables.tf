# variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "modular-payment-system"
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "modularpayment"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_master_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "db_master_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for databases"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot when destroying the Aurora cluster"
  type        = bool
  default     = false
}


variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.r6g.large"
}

variable "publicly_accessible" {
  description = "Set to true if the RDS cluster instances should be publicly accessible"
  type        = bool
  default     = false
}


variable "lambda_policy_arn" {
  description = "ARN of the custom Lambda IAM policy"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the API"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
  default     = ""
}
