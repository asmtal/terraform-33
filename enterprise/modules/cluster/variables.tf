variable "name" {
  description = "The name of the cluster"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs for a virtual private cloud (VPC)"
  type        = list(string)
}

variable "max_size" {
  description = "The maximum number of Amazon EC2 instances in the Auto Scaling group"
  type        = number
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that the Auto Scaling group attempts to maintain"
  type        = number
}

variable "image_id" {
  description = "The Amazon Machine Image ID used for the cluster. See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html"
}

variable "instance_type" {
  description = "EC2 instance type"
}

variable "volume_size" {
  description = "Root volume size"
  type        = number
}

variable "allow_calling_ecs_task_definition_arn" {
  description = "allow_calling_ecs_task_definition"
}

variable "allow_manage_catpost_s3_arn" {
  description = "allow_manage_catpost_s3"
}

variable "allow_logging_arn" {
  description = "allow_logging"
}

variable "allow_autoscaling_arn" {
  description = "allow_autoscaling"
}
