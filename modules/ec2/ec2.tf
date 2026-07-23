resource "aws_instance" "main" {

  ami                    = data.aws_ami.latest.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.selected.id]

  tags = {
    Name = "${var.name}-${var.env_name}"
  }

  root_block_device {
    volume_size           = var.root_volume_size # Disk size in GB
    volume_type           = "gp3"                # General Purpose SSD (Recommended)
    encrypted             = true                 # Best practice security
    delete_on_termination = true                 # Clean up disk if instance is destroyed
  }

}

output "env_name" {
  value = var.env_name
}