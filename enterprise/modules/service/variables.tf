variable "family" {
  description = "A unique name for your task definition."
}

variable "container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document."
}

variable "ecs_cluster_name" {
  description = "ECS Cluster name"
}

variable "desired_count" {
  description = "Desired count"
  type        = number
}

variable "container_port" {
  description = "The port number on the container."
  type        = number
  default     = 0
}

variable "target_group_arn" {
  description = "Target Group ARN"
}

variable "autoscaling_role_arn" {
  description = "Autoscaling Role ARN"
}

variable "allow_get_parameter_arn" {
  description = "allow_get_parameter_arn"
}
