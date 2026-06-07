output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = aws_eks_cluster.this.arn
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_role_arn" {
  description = "EKS node group IAM role ARN."
  value       = aws_iam_role.node_group.arn
}

output "node_security_group_id" {
  description = "Security group ID for worker nodes."
  value       = aws_security_group.nodes.id
}