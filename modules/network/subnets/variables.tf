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

variable "availability_zones" {
  type = list(string)
}