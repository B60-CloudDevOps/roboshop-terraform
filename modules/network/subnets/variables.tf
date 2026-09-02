variable "vpc_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "env" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}