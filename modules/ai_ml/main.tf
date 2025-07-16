provider "aws" {
  region = var.aws_region
}

resource "aws_sagemaker_model" "main" {
  name               = "${var.name_prefix}-sagemaker-model"
  execution_role_arn = aws_iam_role.sagemaker_role.arn

  primary_container {
    # image = data.aws_sagemaker_prebuilt_ecr_image.agent.registry_path
  }

  tags = var.tags
}

resource "aws_iam_role" "sagemaker_role" {
  name               = "${var.name_prefix}-sagemaker-role"
  assume_role_policy = data.aws_iam_policy_document.sagemaker.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "sagemaker_policy" {
  name   = "${var.name_prefix}-sagemaker-policy"
  role   = aws_iam_role.sagemaker_role.id
  policy = data.aws_iam_policy_document.sagemaker_policy.json
}

resource "aws_sagemaker_endpoint" "main" {
  name                 = "${var.name_prefix}-sagemaker-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.main.name
  tags                 = var.tags
}

resource "aws_sagemaker_endpoint_configuration" "main" {
  name = "${var.name_prefix}-sagemaker-endpoint-config"

  production_variants {
    variant_name           = "main"
    model_name             = aws_sagemaker_model.main.name
    initial_instance_count = 1
    instance_type          = "ml.t2.medium"
  }

  tags = var.tags
}
