variable "aws_region" {
  description = "AWS region"
}

variable "account_id" {
  description = "AWS account ID"
}

variable "iam_policy_name_prefix" {
  description = "The name prefix of IAM policies"
  default     = "sider-enterprise"
}

variable "traces_bucket_arn" {
  description = "The ARN of the traces bucket"
}

variable "catpost_bucket_arn" {
  description = "The ARN of the catpost bucket"
}

variable "parameter_store_name_prefix" {
  description = "The name prefix of the parameter stores. Foe example, sider-enterprise/staging"
}
