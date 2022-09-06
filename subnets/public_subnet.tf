

resource "aws_subnet" "public" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_list["${var.az}-public"]
  availability_zone = var.az
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${var.az}"
  }

}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# resource "aws_security_group" "this" {
#   name        = "is311-networking-private-instance"
#   description = "Networking Lab private instance subnet"
#   vpc_id      = aws_vpc.networking_lab.id

#   ingress {
#     description = "MySQL from VPC"
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.networking_lab.cidr_block]
#   }

#   ingress {
#     description = "SSH from VPC"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.networking_lab.cidr_block]
#   }

#   egress {
#     description = "Https to Anywhere"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#   tags = {
#     Name = "is311-networking-private-instance"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }
