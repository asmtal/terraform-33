variable "vpc_id" {
  description = "VPC ID"
}

variable "subnets" {
  description = "Subnets for Load Balancer"
  type        = list(string)
}

variable "port" {
  description = "The port number of the target group"
  type        = number
}

variable "health_check_path" {
  description = "The health check path of the target group"
}

variable "zone_id" {
  description = "Route53 Zone ID"
}

variable "domain_name" {
  description = "THe domain name for the load balancer"
}
