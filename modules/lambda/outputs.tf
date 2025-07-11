output "router_function_arn" {
  description = "Lambda router function ARN"
  value       = aws_lambda_function.router.arn
}
