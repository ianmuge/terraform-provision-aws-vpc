output "vpc" {
  value = aws_vpc.vpc.id
}
output "igw" {
  value = aws_internet_gateway.igw.id
}
output "rtb" {
  value = aws_default_route_table.rtb.id
}
output "private_subnet" {
  value = aws_subnet.private_subnet.*.id
}
output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}
output "sec_group" {
  value = aws_vpc.vpc.default_security_group_id
}
output "public_sec_group" {
  value = aws_security_group_rule.public_ingress.*.id
}
output "private_sec_group" {
  value = aws_security_group_rule.private_ingress.*.id
}
output "secure_sec_group" {
  value = aws_security_group_rule.secure_ingress.*.id
}

