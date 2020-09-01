#!/bin/bash

function error_check_last_command() {
    if [ $? -ne 0 ]; then
        echo "Error with terraform init and config files. Exiting."
        exit 1
    fi
}

mkdir learn-terraform-aws-instance && cd $_
cat <<EOF>example.tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}
EOF

terraform init
terraform fmt
error_check_last_command
terraform validate
error_check_last_command
echo "yes" | terraform apply

# inspect state
terraform show

# store terraform.tfstate securely and remotely!

# get state list
terraform state list

# Can change config (e.g. the AMI) and `terraform apply` to update the changes
