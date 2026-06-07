resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/project-bedrock/${var.name_prefix}/application"
  retention_in_days = var.app_log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name_prefix}-asset-processor"
  retention_in_days = var.app_log_retention_days

  tags = var.tags
}

resource "aws_eks_addon" "cloudwatch_observability" {
  count = var.enable_cloudwatch_addon ? 1 : 0

  cluster_name                = var.eks_cluster_name
  addon_name                  = "amazon-cloudwatch-observability"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}

resource "aws_sns_topic" "alerts" {
  count = var.create_alerts_topic ? 1 : 0

  name = "${var.name_prefix}-alerts"

  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  count = var.create_alerts_topic && var.alert_email_subscription != "" ? 1 : 0

  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "email"
  endpoint  = var.alert_email_subscription
}
