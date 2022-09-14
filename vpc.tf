resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = "Gameday-VPC"
  }
}

module "subnet_cidrs" {
  source          = "hashicorp/subnets/cidr"
  version         = "1.0.0"
  base_cidr_block = aws_vpc.this.cidr_block
  networks        = [for s in local.subnet_list_full : { "name" = s, "new_bits" = 4 }]
}
