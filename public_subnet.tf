resource "aws_subnet" "public" {
  for_each = toset(local.subnet_list_public)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = module.subnet_cidrs.network_cidr_blocks[each.key]
  availability_zone       = element(split("_", each.key), 0)
  map_public_ip_on_launch = true

  tags = {
    Name = "Gameday-${each.value}"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "Gameday-RT-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = toset(local.subnet_list_public)

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# IGW
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "Gameday-IGW"
  }
}
