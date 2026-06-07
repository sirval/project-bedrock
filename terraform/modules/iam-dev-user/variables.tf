variable "name_prefix" {
  description = "Name prefix for IAM resources."
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster that the developer can view."
  type        = string
}

variable "dev_user_name" {
  description = "IAM developer user name."
  type        = string
}

variable "tags" {
  description = "Tags applied to IAM resources."
  type        = map(string)
  default     = {}
}
