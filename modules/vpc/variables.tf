variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = map(any)
}

variable "env" {
  type = string
}