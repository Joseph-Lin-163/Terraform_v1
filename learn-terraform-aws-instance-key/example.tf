terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region = var.region
}

resource "aws_key_pair" "example" {
  key_name   = "examplekey"
  public_key = file("/vagrant/learn-terraform-aws-instance-key/terraform.pub")
}

resource "aws_instance" "example" {
  key_name      = aws_key_pair.example.key_name
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
  security_groups = [
        "default"
    ]

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/vagrant/learn-terraform-aws-instance-key/terraform")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }
}

resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.example.id
}

output "ip" {
  value = aws_eip.ip.public_ip
}
