terraform {
  backend "s3" {
    bucket = "gurukul-vighnesh"
    key    = "workflow/terraform.tfstate"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0b029b1931b347543"
  instance_type          = "t2.micro"
  key_name               = "gurukul-vighnesh"
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "gurukul-vighnesh-esop"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.private_key
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo hello >> temp.txt"
    ]
  }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
  tags = {
    "name" = "Traffic Rules"
  }
}

output "instance_ip_addr" {
  value       = aws_instance.app_server.public_ip
  description = "The public IP address of the main server instance."
} 