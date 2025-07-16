output "ecs_sg_id" {
  description = "ECS Security Group ID"
  value       = aws_security_group.ecs_sg.id
}

output "lambda_sg_id" {
  description = "Lambda Security Group ID"
  value       = aws_security_group.lambda_sg.id
}

output "sagemaker_sg_id" {
  description = "SageMaker Security Group ID"
  value       = aws_security_group.sagemaker_sg.id
}


output "rds_sg_id" {
  description = "RDS Security Group ID"
  value       = aws_security_group.rds_sg.id
}

output "ec2_sg_id" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2_sg.id
}

output "waf_acl_arn" {
  description = "WAF ACL ARN"
  value       = aws_wafv2_web_acl.main.arn
}
