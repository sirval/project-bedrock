output "cart_table_name" {
  description = "DynamoDB cart table name."
  value       = aws_dynamodb_table.carts.name
}

output "database_endpoint" {
  description = "RDS endpoint when enabled."
  value       = var.enable_rds ? aws_db_instance.orders[0].endpoint : null
}

output "redis_primary_endpoint" {
  description = "Redis primary endpoint when enabled."
  value       = var.enable_redis ? aws_elasticache_replication_group.checkout[0].primary_endpoint_address : null
}
