provider "aws" {
  region = var.aws_region
}

resource "aws_sqs_queue" "main" {
  name                      = "${var.name_prefix}-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = var.tags
}

resource "aws_sns_topic" "main" {
  name = "${var.name_prefix}-topic"

  tags = var.tags
}
