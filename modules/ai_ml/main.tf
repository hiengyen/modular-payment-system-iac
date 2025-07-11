provider "aws" {
  region = var.aws_region
}

resource "aws_sagemaker_endpoint" "main" {
  name                 = "${var.name_prefix}-sagemaker-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.main.name

  tags = var.tags
}

resource "aws_sagemaker_endpoint_configuration" "main" {
  name = "${var.name_prefix}-sagemaker-endpoint-config"

  production_variants {
    variant_name           = "main"
    model_name             = aws_sagemaker_model.main.name
    instance_type          = "ml.t2.medium"
    initial_instance_count = 1
  }

  tags = var.tags
}

resource "aws_sagemaker_model" "main" {
  name               = "${var.name_prefix}-sagemaker-model"
  execution_role_arn = aws_iam_role.sagemaker.arn

  primary_container {
    image = "${var.ecr_repository_url}:latest"
  }

  tags = var.tags
}

resource "aws_iam_role" "sagemaker" {
  name = "${var.name_prefix}-sagemaker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "sagemaker_policy" {
  name   = "${var.name_prefix}-sagemaker-policy"
  role   = aws_iam_role.sagemaker.id
  policy = file("${path.module}/../../policies/sagemaker_policy.json")
}
