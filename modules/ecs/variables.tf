variable "name_prefix" {
  type        = string
  description = "Prefix for ECS resources"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "execution_role_arn" {
  type        = string
  description = "ECS execution role ARN"
}

variable "task_role_arn" {
  type        = string
  description = "ECS task role ARN"
}

variable "banking_api_image" {
  type        = string
  description = "Image URL for banking API"
}

variable "langflow_image" {
  type        = string
  description = "Image URL for langflow"
}

variable "banking_api_env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "langflow_env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

