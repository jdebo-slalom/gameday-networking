locals {
  subnet_list = ["web", "db"]
}

resource "aws_subnet" "private" {
  for_each                = toset(local.subnet_list)
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_list["${var.az}-${each.value}"]
  availability_zone       = var.az
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${var.az}-${each.value}"
  }
}

resource "aws_route_table" "private" {
  for_each = toset(local.subnet_list)
  vpc_id   = var.vpc_id
  route    = []

  tags = {
    Name = "gd-rt"
  }

  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_route_table_association" "private" {
  for_each       = toset(local.subnet_list)
  subnet_id      = aws_subnet.private[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}

resource "aws_eip" "this" {
    vpc      = true
}


resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.private["web"].id

  tags = {
    Name = "Lab NAT GW"
  }
}