output "state_bucket_name" {
  description = "S3 bucket used for Terraform remote state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_region" {
  description = "Region of the Terraform state bucket."
  value       = var.aws_region
}