# vpc
resource "aws_vpc" "aws10-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "aws10-vpc"
  }
}

# 퍼블릭 서브넷 2a
resource "aws_subnet" "aws10_public_subnet2a" {
  vpc_id            = aws_vpc.aws10-vpc.id
  cidr_block        = var.public_subnet[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "aws10-public-subnet2a"
  }
}

# 퍼블릭 서브넷 2c
resource "aws_subnet" "aws10_public_subnet2c" {
  vpc_id            = aws_vpc.aws10-vpc.id
  cidr_block        = var.public_subnet[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "aws10-public-subnet2c"
  }
}

# 프라이빗 서브넷 2a
resource "aws_subnet" "aws10_private_subnet2a" {
  vpc_id            = aws_vpc.aws10-vpc.id
  cidr_block        = var.private_subnet[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "aws10-private-subnet2a"
  }
}
# 프라이빗 서브넷 2c
resource "aws_subnet" "aws10_private_subnet2c" {
  vpc_id            = aws_vpc.aws10-vpc.id
  cidr_block        = var.private_subnet[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "aws10-private-subnet2c"
  }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "aws10-igw" {
  vpc_id = aws_vpc.aws10-vpc.id

  tags = {
    Name = "aws10-Internet-gateway"
  }
}

# EIP for NAT Gateway
resource "aws_eip" "aws10-eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.aws10-igw"]
  lifecycle {
    create_before_destroy = true
  }
}

# NAT Gateway
resource "aws_nat_gateway" "aws10-nat" {
  allocation_id = aws_eip.aws10-eip.id
  # NAT를 생성 할 서브넷 위치
  subnet_id  = aws_subnet.aws10_public_subnet2a.id
  depends_on = ["aws_internet_gateway.aws10-igw"]
}

# AWS에서 VPC를 생성하면 자동으로 route table이 하나 생긴다
# aws_default_route_table은 route table을 만들지 않고 VPC가 만든
# 기본 route table을 가져와서 terraform이 관리 할 수 있게 한다.

resource "aws_default_route_table" "aws10_public_rt" {
  default_route_table_id = aws_vpc.aws10-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws10-igw.id
  }
  tags = {
    Name = "aws10 public route table"
  }
}

# Default 라우터를 퍼블릭 서브넷에 연결
resource "aws_route_table_association" "aws10_public_rta_2a" {
  subnet_id      = aws_subnet.aws10_public_subnet2a.id
  route_table_id = aws_default_route_table.aws10_public_rt.id
}

resource "aws_route_table_association" "aws10_public_rta_2c" {
  subnet_id      = aws_subnet.aws10_public_subnet2c.id
  route_table_id = aws_default_route_table.aws10_public_rt.id
}

# 프라이빗 라우트 생성 및 프라이빗 서브넷에 연결
resource "aws_route_table" "aws10_private_rt" {
  vpc_id = aws_vpc.aws10-vpc.id
  tags = {
    Name = "aws10 private route table"
  }
}

resource "aws_route_table_association" "aws10_private_rta_2a" {
  subnet_id      = aws_subnet.aws10_private_subnet2a.id
  route_table_id = aws_route_table.aws10_private_rt.id
}

resource "aws_route_table_association" "aws10_private_rta_2c" {
  subnet_id      = aws_subnet.aws10_private_subnet2c.id
  route_table_id = aws_route_table.aws10_private_rt.id
}

resource "aws_route" "aws10_private_rt_table" {
  route_table_id         = aws_route_table.aws10_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws10-nat.id
}