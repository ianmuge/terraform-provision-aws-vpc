provider "aws" {
  region = var.aws_region
}
data "http" "myip" {
  url = "https://api.ipify.org?format=json"
  request_headers = {
    Accept = "application/json"
  }
}
resource "aws_vpc" "vpc" {
  cidr_block                       = "${var.vpc_ip_base}.0.0/${var.vpc_mask}"
  instance_tenancy                 = var.tenancy
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name      = var.vpc_name
    env       = var.vpc_name
    region    = var.aws_region
    Terraform = "true"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name      = "${var.vpc_name}-IGW"
    env       = var.vpc_name
    region    = var.aws_region
    vpc       = aws_vpc.vpc.id
    Terraform = "true"
  }
}
resource "aws_default_route_table" "rtb" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name      = "${var.vpc_name}-RTB"
    env       = var.vpc_name
    region    = var.aws_region
    vpc       = aws_vpc.vpc.id
    Terraform = "true"
  }
}
resource "aws_subnet" "private_subnet" {
  count                           = length(var.availability_zones)
  cidr_block                      = "${var.vpc_ip_base}.${count.index * var.vpc_increment}.0/${var.subnet_mask}"
  availability_zone               = "${var.aws_region}${var.availability_zones[count.index]}"
  map_public_ip_on_launch         = false
  vpc_id                          = aws_vpc.vpc.id
  tags = {
    Name      = "${var.vpc_name}_private_${var.availability_zones[count.index]}"
    env       = var.vpc_name
    section   = "private"
    zone      = "${var.aws_region}${var.availability_zones[count.index]}"
    Terraform = "true"
  }
}
resource "aws_subnet" "public_subnet" {
  count                           = length(var.availability_zones)
  cidr_block                      = "${var.vpc_ip_base}.${(count.index + 3) * var.vpc_increment}.0/${var.subnet_mask}"
  availability_zone               = "${var.aws_region}${var.availability_zones[count.index]}"
  map_public_ip_on_launch         = true
  vpc_id                          = aws_vpc.vpc.id
  tags = {
    Name      = "${var.vpc_name}_public_${var.availability_zones[count.index]}"
    env       = var.vpc_name
    section   = "public"
    zone      = "${var.aws_region}${var.availability_zones[count.index]}"
    Terraform = "true"
  }
}
resource "aws_default_security_group" "security_group" {
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name      = "${var.vpc_name}-${var.sec_grp_name}"
    env       = var.vpc_name
    region    = var.aws_region
    vpc       = aws_vpc.vpc.id
    Terraform = "true"
  }
}
//resource "aws_security_group_rule" "egress" {
//  type        = "egress"
//  from_port   = 0
//  to_port     = 0
//  protocol    = -1
//  cidr_blocks = ["0.0.0.0/0"]
//  security_group_id = aws_vpc.vpc.default_security_group_id
//}
resource "aws_security_group_rule" "public_ingress" {
  count             = length(var.public_ports)
  description       = "public-${var.vpc_name}-${var.sec_grp_name}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = element(var.public_ports, count.index)
  to_port           = element(var.public_ports, count.index)
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_vpc.vpc.default_security_group_id
}
resource "aws_security_group_rule" "private_ingress" {
  count             = length(var.private_ports)
  description       = "private-${var.vpc_name}-${var.sec_grp_name}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = element(var.private_ports, count.index)
  to_port           = element(var.private_ports, count.index)
  cidr_blocks       = ["${var.vpc_ip_base}.0.0/${var.vpc_mask}"]
  security_group_id = aws_vpc.vpc.default_security_group_id
}
resource "aws_security_group_rule" "secure_ingress" {
  count             = length(var.secure_ports)
  description       = "secure-${var.vpc_name}-${var.sec_grp_name}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = element(var.secure_ports, count.index)
  to_port           = element(var.secure_ports, count.index)
  cidr_blocks       = ["${jsondecode(data.http.myip.body).ip}/32"]
  security_group_id = aws_vpc.vpc.default_security_group_id
}
