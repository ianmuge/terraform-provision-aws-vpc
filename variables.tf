variable "aws_region" {
  description = "AWS region to launch VPC."
  default     = "eu-west-2"
}
variable "vpc_name" {
  description = "VPC Name"
  default     = "General"
}
variable "vpc_ip_base" {
  default = "10.10"
}
variable "vpc_mask" {
  default = "16"
}
variable "tenancy" {
  default = "default"
}
variable "enable_dns_hostnames" {
  default = true
}
variable "enable_dns_support" {
  default = true
}
variable "assign_generated_ipv6_cidr_block" {
  default = true
}
variable "vpc_increment" {
  default = 16
}
variable "subnet_mask" {
  default = 20
}
variable "availability_zones" {
  type    = list(string)
  default = ["a", "b", "c"]
}
variable "sec_grp_name" {
  default = "default"
}
variable "sec_grp_desc" {
  default = "VPC Default Security Group"
}
variable "public_ports" {
  type = list(string)
  default = [
    80, #http
    443 #https
  ]
}
variable "private_ports" {
  type = list(string)
  default = [
    3306, #MySQL
    6379, #Redis
    2049, #NFS
    9200, #elasticsearch
    5601  #kibana
  ]

}
variable "secure_ports" {
  type = list(string)
  default = [
    22,  #ssh
    3389 #rdp
  ]
}