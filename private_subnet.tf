resource "aws_subnet" "private" {
  for_each = toset(local.subnet_list_private)
  # Each item looks like us-west-2a_app

  vpc_id                  = aws_vpc.this.id
  cidr_block              = module.subnet_cidrs.network_cidr_blocks[each.key]
  availability_zone       = element(split("_", each.key), 0)
  map_public_ip_on_launch = false

  tags = {
    Name = "Gameday-${each.value}"
  }
}

resource "aws_route_table" "private" {
  for_each = toset(local.subnet_list_private)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "Gameday-RT-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = toset(local.subnet_list_private)

  subnet_id      = aws_subnet.private[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}


# One NAT gateway
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.private, 0).id

  tags = {
    Name = "Gameday-NATGW"
  }
}
