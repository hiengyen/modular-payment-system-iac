output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "banking_api_service_name" {
  value = aws_ecs_service.banking_api.name
}

output "langflow_service_name" {
  value = aws_ecs_service.langflow.name
}

output "target_group_arn" {
  description = "ALB target group ARN"
  value       = aws_lb_target_group.main.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.main.stage_name}"
}
