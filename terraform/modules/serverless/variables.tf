variable "name_prefix" {
  description = "Name prefix for serverless resources."
  type        = string
}

variable "lambda_source_dir" {
  description = "Local directory containing Lambda source code."
  type        = string
}

variable "asset_bucket_name" {
  description = "Optional explicit S3 bucket name for uploaded assets."
  type        = string
  default     = ""
}

variable "force_destroy_bucket" {
  description = "Allow deleting the asset bucket with objects still inside."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to serverless resources."
  type        = map(string)
  default     = {}
}
