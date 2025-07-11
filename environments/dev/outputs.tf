output "vpc_id" {
  description = "VPC ID"
  value       = module.main.vpc_id
}

output "api_gateway_url" {
  description = "API Gateway URL"
  value       = module.main.api_gateway_url
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.main.cognito_user_pool_id
}

output "cognito_client_id" {
  description = "Cognito User Pool Client ID"
  value       = module.main.cognito_client_id
}

output "aurora_cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = module.main.aurora_cluster_endpoint
}

output "aurora_reader_endpoint" {
  description = "Aurora reader endpoint"
  value       = module.main.aurora_reader_endpoint
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.main.dynamodb_table_name
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.main.s3_bucket_name
}

output "ecr_banking_api_repository_url" {
  description = "ECR Banking API repository URL"
  value       = module.main.ecr_banking_api_repository_url
}

output "ecr_langflow_repository_url" {
  description = "ECR Langflow repository URL"
  value       = module.main.ecr_langflow_repository_url
}

output "quicksight_dashboard_url" {
  description = "QuickSight dashboard URL"
  value       = module.main.quicksight_dashboard_url
}

output "sagemaker_endpoint_name" {
  description = "SageMaker endpoint name"
  value       = module.main.sagemaker_endpoint_name
}

output "waf_acl_arn" {
  description = "WAF ACL ARN"
  value       = module.main.waf_acl_arn
}
