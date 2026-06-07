variable "name_prefix" {
  description = "Name prefix for observability resources."
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "enable_cloudwatch_addon" {
  description = "Install the Amazon CloudWatch Observability EKS add-on."
  type        = bool
  default     = true
}

variable "app_log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 30
}

variable "create_alerts_topic" {
  description = "Create an SNS topic for alerts."
  type        = bool
  default     = false
}

variable "alert_email_subscription" {
  description = "Optional email subscription endpoint."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to observability resources."
  type        = map(string)
  default     = {}
}
