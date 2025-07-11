provider "aws" {
  region = var.aws_region
}

resource "aws_kinesis_firehose_delivery_stream" "main" {
  name        = "${var.name_prefix}-firehose"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose.arn
    bucket_arn         = "arn:aws:s3:::${var.s3_bucket_name}"
    buffer_size        = 5
    buffer_interval    = 300
  }

  tags = var.tags
}

resource "aws_quicksight_data_source" "main" {
  data_source_id = "${var.name_prefix}-quicksight-datasource"
  name           = "${var.name_prefix}-quicksight-datasource"

  type = "AURORA_POSTGRESQL"

  parameters {
    aurora_postgresql {
      host   = var.aurora_endpoint
      port   = 5432
      database = "${var.name_prefix}db"
    }
  }

  tags = var.tags
}

resource "aws_iam_role" "firehose" {
  name = "${var.name_prefix}-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "firehose_policy" {
  name   = "${var.name_prefix}-firehose-policy"
  role   = aws_iam_role.firehose.id
  policy = file("${path.module}/../../policies/firehose_policy.json")
}
