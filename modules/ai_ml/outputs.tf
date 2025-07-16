output "sagemaker_endpoint_name" {
  description = "SageMaker endpoint name"
  value       = aws_sagemaker_endpoint.main.name
}


output "sagemaker_role_name" {
  description = "Name of the SageMaker IAM role"
  value       = aws_iam_role.sagemaker_role.name
}

output "sagemaker_role_arn" {
  description = "ARN of the SageMaker IAM role"
  value       = aws_iam_role.sagemaker_role.arn
}

output "sagemaker_policy_name" {
  description = "Name of the IAM inline policy"
  value       = aws_iam_role_policy.sagemaker_policy.name
}

output "sagemaker_model_name" {
  description = "The name of the SageMaker model"
  value       = aws_sagemaker_model.main.name
}

output "sagemaker_model_arn" {
  description = "The ARN of the SageMaker model"
  value       = aws_sagemaker_model.main.arn
}

