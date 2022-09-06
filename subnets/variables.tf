variable "vpc_id" {
  description = "VPC ID to create networking resources in."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR Range for the VPC"
}

variable "az" {}
variable "internet_gateway" {}
variable "subnet_cidr_list" {}