variable "vpc_id" {
  description = "vpc_id"
}

variable "security_group_ids_to_allow" {
  description = "security_group_ids_to_allow"
  type        = list(string)
}

variable "subnet_ids" {
  description = "subnet_ids"
  type        = list(string)
}

variable "instance_class" {
  description = "instance_class"
  default     = "db.t2.micro"
}

variable "username" {
  description = "username"
}

variable "password" {
  description = "password"
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes."
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "The days to retain backups for."
  type        = number
  default     = 1
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled."
  default     = "08:32-09:02"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in."
  default     = "fri:18:00-fri:18:30"
}
