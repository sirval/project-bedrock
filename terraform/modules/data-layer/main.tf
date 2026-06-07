resource "aws_dynamodb_table" "carts" {
  name         = "${var.name_prefix}-carts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "customer_id"

  attribute {
    name = "customer_id"
    type = "S"
  }

  tags = var.tags
}

resource "aws_security_group" "data" {
  name        = "${var.name_prefix}-data-sg"
  description = "Data layer access from the project VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Redis from VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-data-sg"
  })
}

resource "aws_db_subnet_group" "this" {
  count = var.enable_rds ? 1 : 0

  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "orders" {
  count = var.enable_rds ? 1 : 0

  identifier                  = "${var.name_prefix}-orders"
  engine                      = "postgres"
  engine_version              = "16"
  instance_class              = "db.t4g.micro"
  allocated_storage           = 20
  db_name                     = var.database_name
  username                    = var.database_username
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.this[0].name
  vpc_security_group_ids      = [aws_security_group.data.id]
  backup_retention_period     = 7
  deletion_protection         = var.deletion_protection
  skip_final_snapshot         = !var.deletion_protection

  tags = var.tags
}

resource "aws_elasticache_subnet_group" "this" {
  count = var.enable_redis ? 1 : 0

  name       = "${var.name_prefix}-redis-subnets"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

resource "aws_elasticache_replication_group" "checkout" {
  count = var.enable_redis ? 1 : 0

  replication_group_id       = "${var.name_prefix}-checkout"
  description                = "Redis cache for checkout sessions"
  engine                     = "redis"
  node_type                  = "cache.t4g.micro"
  num_cache_clusters         = 1
  port                       = 6379
  automatic_failover_enabled = false
  subnet_group_name          = aws_elasticache_subnet_group.this[0].name
  security_group_ids         = [aws_security_group.data.id]

  tags = var.tags
}
