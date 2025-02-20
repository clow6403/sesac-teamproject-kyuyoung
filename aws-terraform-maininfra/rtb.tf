resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "pub-rtb"
  }
}

resource "aws_route_table" "pvt_rtb" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "pvt-rtb"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.pvt_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.bastion.primary_network_interface_id
}

resource "aws_route_table_association" "pub_2a_association" {
  subnet_id = aws_subnet.pub_2a.id
  route_table_id = aws_route_table.pub_rtb.id
}
resource "aws_route_table_association" "pub_2c_association" {
  subnet_id = aws_subnet.pub_2c.id
  route_table_id = aws_route_table.pub_rtb.id
}


resource "aws_route_table_association" "pvt_2a_association" {
  subnet_id = aws_subnet.pvt_2a.id
  route_table_id = aws_route_table.pvt_rtb.id
}

resource "aws_route_table_association" "pvt_2c_association" {
  subnet_id = aws_subnet.pvt_2c.id
  route_table_id = aws_route_table.pvt_rtb.id
}