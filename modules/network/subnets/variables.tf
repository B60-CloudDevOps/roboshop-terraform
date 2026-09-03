variable "vpc_id" {
  type = string
}

variable "cidr_block" {
  type = list(string)
}

variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "map_public_ip" {
  type    = bool
  default = false
}

variable "availability_zones" {
  type = list(string)
}

variable "igw_id" {
  type = string
}

variable "use_nat_gateway" {
  type    = bool
  default = false
}

variable "nat_gateway_ids" {
  type    = list(string)
  default = []
}