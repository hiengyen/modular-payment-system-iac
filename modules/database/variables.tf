variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "modularpayment"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "db_master_username" {
  description = "Database master username"
  type        = string
}

variable "db_master_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for databases"
  type        = bool
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ecs_sg_id" {
  description = "ECS Security Group ID"
  type        = string
}

variable "lambda_sg_id" {
  description = "Lambda Security Group ID"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot when destroying the Aurora cluster"
  type        = bool
  default     = false
}

