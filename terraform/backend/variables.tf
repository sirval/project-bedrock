variable "aws_region" {
  description = "AWS region for the Terraform backend."
  type        = string
  default     = "us-east-1"
}

variable "student_id" {
  description = "Unique lowercase student ID or name suffix for the Terraform state bucket."
  type        = string
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket used for Terraform remote state."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to backend resources."
  type        = map(string)

  default = {
    Project = "karatu-2025-capstone"
  }
}