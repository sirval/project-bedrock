variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "project-bedrock"
}

variable "cluster_name" {
  type    = string
  default = "project-bedrock-cluster"
}

variable "vpc_name" {
  type    = string
  default = "project-bedrock-vpc"
}

variable "app_namespace" {
  type    = string
  default = "retail-app"
}

variable "dev_iam_user" {
  type    = string
  default = "bedrock-dev-view"
}

variable "lambda_name" {
  type    = string
  default = "bedrock-asset-processor"
}

variable "student_id" {
  type = string
}

variable "common_tags" {
  type = map(string)

  default = {
    Project = "karatu-2025-capstone"
  }
}