terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

provider "aws" {
  region = var.region
  profile = "terraform-demo"
}

locals {
  time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}

resource "aws_key_pair" "tdemo1" {
  key_name   = "tdemo1"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_security_group" "fdemo-sg" {
  name        = "tdemo-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
	cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
	cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fdemo-sg"
  }
}

resource "aws_instance" "webserver" {
  ami           = lookup(var.ami,var.region)
  instance_type = "t3.micro"
  key_name = aws_key_pair.tdemo1.key_name
  vpc_security_group_ids = [aws_security_group.fdemo-sg.id]
  count = 2

  tags = {
    Name = element(var.tags,count.index)
    Env = "dev"
    Project = "functions-demo"
  }
}
