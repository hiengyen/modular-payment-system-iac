output "target_group_arn" {
  description = "ALB target group ARN"
  value       = aws_lb_target_group.main.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

