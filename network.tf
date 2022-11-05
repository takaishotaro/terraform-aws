
# ---------------------------------------------
# VPC
# ---------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "${var.env_code}-vpc"
  }
}

# ---------------------------------------------
# Subnet
# ---------------------------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = var.public_cidr[0]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_code}-public-subnet-1a"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = var.public_cidr[1]

  tags = {
    Name = "${var.env_code}-public-subnet-1c"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = var.private_cidr[0]

  tags = {
    Name = "${var.env_code}-private-subnet-1a"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = var.private_cidr[1]

  tags = {
    Name = "${var.env_code}-private-subnet-1c"
  }
}


# ---------------------------------------------
# Route Table
# ---------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env_code}-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env_code}-private-rt-1a"
  }
}

resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env_code}-private-rt-1c"
  }
}

resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt_1a.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}

resource "aws_route_table_association" "private_rt_1c" {
  route_table_id = aws_route_table.private_rt_1c.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}


# ---------------------------------------------
# Internet Gateway
# ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env_code}-private-igw"
  }
}

resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# ---------------------------------------------
# Elastic IP
# ---------------------------------------------
resource "aws_eip" "ngw_1a" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.env_code}-eip-ngw-1a"
  }
}

resource "aws_eip" "ngw_1c" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.env_code}-eip-ngw-1c"
  }
}

# ---------------------------------------------
# NAT Gateway
# ---------------------------------------------
resource "aws_nat_gateway" "ngw_1a" {
  allocation_id = aws_eip.ngw_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.env_code}-ngw-1a"
  }
}

resource "aws_nat_gateway" "ngw_1c" {
  allocation_id = aws_eip.ngw_1c.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.env_code}-ngw-1a"
  }
}

resource "aws_route" "public_rt_ngw_1a" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw_1a.id
}

resource "aws_route" "public_rt_ngw_1c" {
  route_table_id         = aws_route_table.private_rt_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw_1c.id
}
