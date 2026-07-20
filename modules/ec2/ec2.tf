
resource "aws_instance" "main" {

  ami           = data.aws_ami.latest.id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  tags = {
    Name = "${var.name}-${var.env_name}"
  }
}

output "env_name" {
    value = var.env_name
}