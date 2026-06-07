variable "name_prefix" {
  description = "Name prefix for data resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR allowed to reach data services."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for managed data services."
  type        = list(string)
}

variable "enable_rds" {
  description = "Create PostgreSQL RDS."
  type        = bool
  default     = false
}

variable "enable_redis" {
  description = "Create ElastiCache Redis."
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Database name."
  type        = string
}

variable "database_username" {
  description = "Database username."
  type        = string
}

variable "deletion_protection" {
  description = "Protect stateful database resources from accidental deletion."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to data resources."
  type        = map(string)
  default     = {}
}
