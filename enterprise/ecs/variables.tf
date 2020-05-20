variable "sider_enterprise_release_version" {
  description = "Sider Enterprise release version"
  default     = "release-202001.1"
}

variable "aws_access_key_id_for_sider" {
  description = "AWS_ACCESS_KEY_ID to pull Sider Enterprise Docker images"
}

variable "aws_secret_access_key_for_sider" {
  description = "AWS_SECRET_ACCESS_KEY to pull Sider Enterprise Docker images"
}

variable "parameter_store_name_prefix" {
  description = "The namespace of Sider Enterprise on SSM Parameter Store"
  default     = "/sider_enterprise"
}
