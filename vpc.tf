resource "aws_vpc" "this" {
  cidr_block = "172.32.0.0/16"

  tags = {
    Name = "gd-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "Internet Gateway"
  }
}
