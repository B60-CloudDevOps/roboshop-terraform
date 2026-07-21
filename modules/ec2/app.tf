# This has to be executed after the EC2 instance is created, so we will create a null resource and use remote-exec provisioner to execute the commands on the EC2 instance. We will use the private IP of the EC2 instance to connect to it and execute the commands.
resource "null_resource" "app" {
    depends_on = [aws_instance.main, aws_route53_record.a_record]  
    # This will be created only after the EC2 instance and Route53 record is created

    provisioner "remote-exec" {
        connection {
            type     = "ssh"
            user     = "ec2-user"  #local.get_ssh_user
            password = "DevOps321" #local.get_ssh_pass
            host     = aws_instance.main.private_ip
        }
        inline = [
            "pip3.11 install ansible",
            "type ansible",
            "pip3.11 install hvac",
            "ansible-pull -U https://github.com/B60-CloudDevOps/roboshop-ansible.git roboshop/roboshop-pull.yml -e env=${var.env_name} -e component=${var.name} -e token=${var.vault_token}"
        ]
    }
}