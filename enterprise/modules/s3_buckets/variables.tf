variable "bucket_prefix" {
  description = "The bucket prefix"
  default     = "sider-enterprise"
}

variable "expiration_days" {
  description = "The expiration days for the catpost bucket"
  type        = number
  default     = 7
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "aws_region" {
  description = "AWS region"
}

variable "catpost_vpc_endpoint_route_table_ids" {
  description = "The route table IDs for catpost the VPC endpoint"
  type        = list(string)
}
