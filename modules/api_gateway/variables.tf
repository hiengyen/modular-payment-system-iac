variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}

variable "lambda_router_invoke_arn" {
  description = "Invoke ARN of the router Lambda function"
  type        = string
}

variable "ecs_target_group_arn" {
  description = "ECS target group ARN"
  type        = string
}

variable "ecs_alb_dns_name" {
  description = "Public DNS name of ECS ALB"
  type        = string
}


variable "lambda_router_arn" {
  description = "Lambda router function ARN"
  type        = string
}

variable "waf_acl_arn" {
  description = "WAF ACL ARN"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
