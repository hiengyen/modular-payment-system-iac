variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "modularpayment"
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


variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "aurora_endpoint" {
  description = "Aurora cluster endpoint"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
}
