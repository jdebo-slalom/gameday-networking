provider "aws" {
  region = var.region
}

locals {
  az_list             = formatlist("%s%s", var.region, ["a", "b"])
  subnet_list_private = flatten([for az in local.az_list : [for s in ["app", "db"] : "${az}_${s}"]])
  subnet_list_public  = flatten([for az in local.az_list : [for s in ["public"] : "${az}_${s}"]])
  subnet_list_full    = concat(local.subnet_list_private, local.subnet_list_public)
}

variable "region" {
  default = "us-west-2"
}

variable "cidr_block" {
  type        = string
  description = "IP range to use for this VPC"
  default     = "10.0.0.0/16"
}

output "cidrs" {
  value = module.subnet_cidrs.network_cidr_blocks
}
