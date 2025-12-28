resource "aws_vpc" "this" {
  count      = var.create_vpc ? 1 : 0
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "this" {
  count      = var.create_vpc ? 1 : 0
  vpc_id     = aws_vpc.this[0].id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "${var.environment}-subnet"
  }
}

resource "aws_internet_gateway" "this" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.this[0].id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_route_table" "this" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = {
    Name = "${var.environment}-rt"
  }
}

resource "aws_route_table_association" "this" {
  count          = var.create_vpc ? 1 : 0
  subnet_id      = aws_subnet.this[0].id
  route_table_id = aws_route_table.this[0].id
}

resource "aws_default_vpc" "default" {
  count = var.create_vpc ? 0 : 1
  tags = {
    Name = "default"
  }
}
