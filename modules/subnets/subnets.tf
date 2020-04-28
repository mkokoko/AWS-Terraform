// Resources for private subnets
resource "aws_subnet" "private" {
  count             = length(var.vpc_private_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = element(var.vpc_private_subnets, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = merge(
    {
      Name = element(var.vpc_private_subnet_name, count.index)
      type = var.private_subnet_type
    },
    var.private_subnet_additional_tags
  )
}

resource "aws_eip" "nat" {
  count = length(var.vpc_public_subnets)
  vpc   = true
}

// TODO: rework this to create NAT gateways in AZs instead on relying of subnets.
// AWS recommends to have NAT GW in each AZ. It should be connected to public subnet,
// but route traffic from private ones.

resource "aws_nat_gateway" "private" {
  count         = length(var.vpc_public_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table" "private" {
  count  = length(var.vpc_private_subnets)
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.private.*.id, count.index)
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-private-${count.index}"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.vpc_private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

// Resources for public subnets
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = var.igw_name
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "${var.vpc_name}-public"
    }
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.internet-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_subnet" "public" {
  count             = length(var.vpc_public_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = element(var.vpc_public_subnets, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = merge(
    {
      Name = element(var.vpc_public_subnet_name, count.index)
      type = var.public_subnet_type
    },
    var.public_subnet_additional_tags
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.vpc_public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
