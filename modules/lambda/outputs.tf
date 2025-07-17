# Output for router_function ARN
output "router_function_arn" {
  description = "ARN of the router Lambda function"
  value       = aws_lambda_function.router.arn
}

output "router_function_invoke_arn" {
  value = aws_lambda_function.router.invoke_arn
}

# Output for Lambda role ARN
output "lambda_policy_arn" {
  value = aws_iam_policy.lambda_policy.arn
}






