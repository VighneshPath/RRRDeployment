terraform {
  backend "s3" {
    bucket = "gurukul-vighnesh"
    key    = "workflow/terraform.tfstate"
    region = "us-east-1"
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
  region = "us-east-1"
}

resource "aws_subnet" "subnet" {
  vpc_id                  = "vpc-019c09a1a0c5b4f6b"
  cidr_block              = "10.0.0.160/28"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Custom Subnet"
  }
}

# resource "aws_internet_gateway" "gw" {
#   vpc_id = "vpc-019c09a1a0c5b4f6b"
#   tags = {
#     Name = "Custom Gateway"
#   }
# }

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
    Name = "Traffic Rules"
  }
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0b029b1931b347543"
  instance_type          = "t2.micro"
  key_name               = "gurukul-vighnesh"
  subnet_id              = aws_subnet.subnet.id
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
      "sudo yum update",
      "sudo yum install -y java-17-amazon-corretto-devel"
    ]
  }
}

output "instance_ip_addr" {
  value       = aws_instance.app_server.public_ip
  description = "The public IP address of the main server instance."
} 