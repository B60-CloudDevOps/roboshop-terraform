variable "cluster_name" {
  type = string
}

variable "env" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "node_group_desired_size" {
  type = number

}

variable "node_group_max_size" {
  type = number
}

variable "node_group_min_size" {
  type = number
}

variable "instance_types" {
  type = list(string)
}

# DB Variables
variable "env_name" {}
variable "ami_name" {}
variable "sg_name" {}
variable "components" {}
variable "domain_name" {}
variable "vault_token" {}
variable "iam_policy" {

}