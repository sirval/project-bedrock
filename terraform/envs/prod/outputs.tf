# These EKS and serverless outputs are required for final grading.
# They will be restored after the EKS and serverless modules are created.

# output "cluster_endpoint" {
#   description = "EKS cluster endpoint."
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_name" {
#   description = "EKS cluster name."
#   value       = module.eks.cluster_name
# }

output "region" {
  description = "AWS region."
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

# output "assets_bucket_name" {
#   description = "S3 bucket name for asset uploads."
#   value       = module.serverless.assets_bucket_name
# }