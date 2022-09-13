terraform {}

provider "aws" {
  region = "us-west-2"
}

locals {
  az_list          = ["us-west-2a", "us-west-2b"]
  subnet_list      = ["web", "db"]
  subnet_list_full = [for x in local.az_list : [for y in concat(local.subnet_list, ["public"]) : "${x}-${y}"]]
}


module "subnets" {
  source           = "./subnets"
  for_each         = toset(local.az_list)
  vpc_id           = aws_vpc.this.id
  vpc_cidr         = aws_vpc.this.cidr_block
  az               = each.value
  internet_gateway = aws_internet_gateway.this.id
  subnet_cidr_list = tomap(module.subnet_cidrs[each.value].network_cidr_blocks)
}

module "subnet_cidrs" {
  source          = "hashicorp/subnets/cidr"
  for_each        = toset(local.az_list)
  version         = "1.0.0"
  base_cidr_block = aws_vpc.this.cidr_block
  networks        = [for x in flatten(local.subnet_list_full) : { "name" = x, "new_bits" = 10 }]
}

output "cidrs" {
  value = flatten(local.subnet_list_full)
}