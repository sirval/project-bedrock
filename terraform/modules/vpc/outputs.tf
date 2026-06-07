output "vpc_id" {
  description = "Project Bedrock VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  value       = aws_subnet.private[*].cidr_block
}

output "public_subnet_ids_csv" {
  description = "Public subnet IDs as comma-separated values."
  value       = join(",", aws_subnet.public[*].id)
}

output "private_subnet_ids_csv" {
  description = "Private subnet IDs as comma-separated values."
  value       = join(",", aws_subnet.private[*].id)
}