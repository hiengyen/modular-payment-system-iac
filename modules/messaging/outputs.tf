output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = aws_sqs_queue.main.url
}

output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = aws_sns_topic.main.arn
}
