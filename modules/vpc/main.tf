resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.cluster_name}-vpc"
    "Kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}


resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.cluster_name}-private-subnet-${count.index + 1}"
    "Kubernetes.io/role/internal-elb" = "1"
    "Kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  
}


resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public-subnet-${count.index + 1}"
    "Kubernetes.io/role/elb" = "1"
    "Kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-igw"
    "Kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.cluster_name}-public-route-table"
    "Kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}

resource "aws_nat_gateway" "main" {
    count = length(var.public_subnet_cidrs)
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public[0].id
    
    tags = {
        Name = "${var.cluster_name}-nat-gateway"
        "Kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
  
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count = length(var.private_subnet_cidrs)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id        

  } 

  tags = {
    Name = "${var.cluster_name}-private-route-table-${count.index + 1}"
    "Kubernetes.io/cluster/${var.cluster_name}" = "shared"
  } 
}


resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
  
}