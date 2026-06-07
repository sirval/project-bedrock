output "application_log_group_name" {
  description = "Application CloudWatch log group name."
  value       = aws_cloudwatch_log_group.application.name
}

output "alerts_topic_arn" {
  description = "SNS alerts topic ARN when enabled."
  value       = var.create_alerts_topic ? aws_sns_topic.alerts[0].arn : null
}
