# aws ami datasource
data "aws_ami" "latest" {
    most_recent = true
    
    filter {
        name   = "name"
        values = ["${var.ami_name}"] # Name of the AMI, you can find it in the AWS console or by using AWS CLI
    }
        
    owners = ["self"] # Owner ID of the AMI, you can find it in the AWS console or by using AWS CLI
}

# Datasource for security group, we will use this in the EC2 module to attach the security group to the instance
data "aws_security_group" "selected" {
  name = var.sg_name
}

# Datasource for route53 zone, we will use this in the route53 module to create the record in the selected zone 
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

# data "vault_generic_secret" "ssh_cred" {
#   path = "roboshop-${var.env_name}/ssh_cred"
# }