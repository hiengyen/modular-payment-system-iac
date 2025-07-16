provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "ecs_sg" {
  name_prefix = "${var.name_prefix}-ecs-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-ecs-sg"
    }
  )
}

resource "aws_security_group" "lambda_sg" {
  name_prefix = "${var.name_prefix}-lambda-sg-"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-lambda-sg"
    }
  )
}

# create a security group for SSM to allow access to EC2 instances
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow database access"
  vpc_id      = var.vpc_id

}

# Create a security group for SSM to allow access to EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow EC2 instances to access SSM"
  vpc_id      = var.vpc_id
}

# Tách rule ra để tránh vòng lặp
resource "aws_security_group_rule" "rds_ingress_from_ec2" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ec2_egress_to_vpc" {
  type              = "egress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.ec2_sg.id
}


resource "aws_security_group" "sagemaker_sg" {
  name_prefix = "${var.name_prefix}-sagemaker-sg-"
  description = "Security Group for SageMaker"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-sagemaker-sg"
    }
  )
}


resource "aws_wafv2_web_acl" "main" {
  name        = "${var.name_prefix}-waf-acl"
  description = "WAF for API protection"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-waf-metrics"
      sampled_requests_enabled   = true
    }

  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name_prefix}-waf-metrics"
    sampled_requests_enabled   = true
  }

  tags = var.tags
}
