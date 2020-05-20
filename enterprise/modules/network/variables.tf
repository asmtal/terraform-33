variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
}

variable "public_subnet1" {
  description = "The parameter of the first public subnet"
  type = object({
    cidr_block        = string
    availability_zone = string
  })
}

variable "public_subnet2" {
  description = "The parameter of the second public subnet"
  type = object({
    cidr_block        = string
    availability_zone = string
  })
}

variable "private_subnet1" {
  description = "The parameter of the first private subnet"
  type = object({
    cidr_block        = string
    availability_zone = string
  })
}

variable "private_subnet2" {
  description = "The parameter of the second private subnet"
  type = object({
    cidr_block        = string
    availability_zone = string
  })
}
