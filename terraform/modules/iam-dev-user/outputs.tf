output "dev_user_name" {
  description = "Developer IAM user name."
  value       = aws_iam_user.dev.name
}

output "dev_user_arn" {
  description = "Developer IAM user ARN."
  value       = aws_iam_user.dev.arn
}

output "dev_group_name" {
  description = "Developer viewer IAM group name."
  value       = aws_iam_group.dev_viewers.name
}
