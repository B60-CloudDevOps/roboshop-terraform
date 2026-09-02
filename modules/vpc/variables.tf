variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = map(any)
}

variable "env" {
  type = string
}

variable "vault_token" {
  type = string
}

variable "env" {
  type = string
}