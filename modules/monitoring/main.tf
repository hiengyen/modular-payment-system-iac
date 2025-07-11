provider "aws" {
  region = var.aws_region
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.name_prefix}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", "${var.name_prefix}-ecs-cluster"],
            ["AWS/Lambda", "Invocations", "FunctionName", "${var.name_prefix}-router"],
            ["AWS/Lambda", "Invocations", "FunctionName", "${var.name_prefix}-processor"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "ECS and Lambda Metrics"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  alarm_name          = "${var.name_prefix}-ecs-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when ECS CPU exceeds 80%"
  dimensions = {
    ClusterName = "${var.name_prefix}-ecs-cluster"
  }

  tags = var.tags
}
