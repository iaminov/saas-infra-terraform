locals {
  # Calculate subnet CIDRs based on VPC CIDR
  public_subnet_cidrs = [for i in range(length(var.azs)) : 
    cidrsubnet(var.vpc_cidr, 8, i)]
  
  private_subnet_cidrs = [for i in range(length(var.azs)) : 
    cidrsubnet(var.vpc_cidr, 8, i + length(var.azs))]

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, {
    Name = "${var.environment}-vpc"
  })
}

# Public subnets
resource "aws_subnet" "public" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  
  tags = merge(local.tags, {
    Name = "${var.environment}-public-${var.azs[count.index]}"
    Tier = "public"
  })
}

# Private subnets
resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  
  tags = merge(local.tags, {
    Name = "${var.environment}-private-${var.azs[count.index]}"
    Tier = "private"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(local.tags, {
    Name = "${var.environment}-igw"
  })
}
