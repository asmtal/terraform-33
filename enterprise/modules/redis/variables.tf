variable "vpc_id" {
  description = "VPC ID"
}

variable "replication_group_id" {
  description = "replication_group_id"
}

variable "node_type" {
  description = "node_type"
  default     = "cache.t2.micro"
}

variable "auth_token" {
  description = "auth_token"
}

variable "security_group_ids_to_allow" {
  description = "security_group_ids_to_allow"
  type        = list(string)
}

variable "subnet_ids" {
  description = "subnet_ids"
  type        = list(string)
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed."
  default     = "sat:18:30-sat:19:30"
}

variable "snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. "
  default     = "15:00-16:00"
}
