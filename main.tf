terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "tdemo1" {
  key_name   = "tdemo1"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_security_group" "tdemo-sg" {
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
    Name = "tdemo-sg"
  }
}

resource "aws_instance" "webserver" {
  ami           = "ami-09d3b3274b6c5d4aa"
  instance_type = "t2.micro"
  key_name = "tdemo1"
  vpc_security_group_ids = [aws_security_group.tdemo-sg.id]

  tags = {
    Name = "Web Server"
    Env = "dev"
    Project = "demo"
  }
}
