# Defining IAM role for router_function
resource "aws_iam_role" "router_lambda_role" {
  name = "${var.name_prefix}-router-lambda-role"

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

# Attaching IAM policy to router_lambda_role
resource "aws_iam_role_policy_attachment" "router_lambda_policy" {
  role       = aws_iam_role.router_lambda_role.name
  policy_arn = var.lambda_policy_arn
}

# Defining Lambda function for routing
resource "aws_lambda_function" "router" {
  function_name = "${var.name_prefix}-router"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.router_lambda_role.arn

  filename         = "${path.module}/src/router/router.zip"
  source_code_hash = filebase64sha256("${path.module}/src/router/router.zip")

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      SQS_QUEUE_URL       = var.sqs_queue_url
      S3_BUCKET_NAME      = var.s3_bucket_name
      AURORA_ENDPOINT     = var.aurora_endpoint
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }

  memory_size = 128
  timeout     = 30

  tags = var.tags
}

# Creating CloudWatch log group for router_function
resource "aws_cloudwatch_log_group" "router_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.router.function_name}"
  retention_in_days = 14
  tags              = var.tags
}

