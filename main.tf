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
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}


output "instance_ip_addr" {
  value       = aws_instance.app_server.private_ip
  description = "The private IP address of the main server instance."
} 