output "cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS region."
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

# This output is required for final grading.
# It will be uncommented after the serverless module is created.
# output "assets_bucket_name" {
#   description = "S3 bucket name for asset uploads."
#   value       = module.serverless.assets_bucket_name
# }