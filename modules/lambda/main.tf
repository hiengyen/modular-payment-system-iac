provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "lambda" {
  name = "${var.name_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.name_prefix}-lambda-policy"
  path        = "/"
  description = "Custom policy for Lambda"
  policy      = file("${path.module}/../../policies/lambda_policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "lambda_custom_policy" {
  name   = "${var.name_prefix}-lambda-policy"
  role   = aws_iam_role.lambda.id
  policy = file("${path.module}/../../policies/lambda_policy.json")
}
