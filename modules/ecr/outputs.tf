output "banking_api_repository_url" {
  description = "ECR Banking API repository URL"
  value       = aws_ecr_repository.banking_api.repository_url
}

output "langflow_repository_url" {
  description = "ECR Langflow repository URL"
  value       = aws_ecr_repository.langflow.repository_url
}
