variable "cluster_name" {
  type = string
}

variable "eks_version" {
  type    = string
  default = "1.35"
}

variable "subnet_ids" {
  type = list(string)
}

variable "env" {
  type = string
}

variable "node_group_desired_size" {
  type    = number
  default = 2
}

variable "node_group_max_size" {
  type    = number
  default = 5
}

variable "node_group_min_size" {
  type    = number
  default = 1
}

variable "instance_types" {
  type = list(string)
}