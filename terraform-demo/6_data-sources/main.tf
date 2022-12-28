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
  profile = "terraform-demo"
}


data "aws_ami" "app_ami" {
  most_recent = true
  owners = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_key_pair" "tdemo1" {
  key_name   = "tdemo1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD8p09MVlfOSAgo5s73uonKWhK91hytr++lgq34S2Je/24ZJ/VvK42nuC83OZFkwKCrssVBbO8w8ogSmfp5j1mkPrLypCX4tk70u/KzRsbXmCHbGWrHnzgSn9Q0nhr7Bxoh1hGxLcTPovaWy8PIYeah13vtDhdDvLS7Eg+lzqV1t9uItviWrHe8LInYbJdsInqL07/j3bMQ4YJg+NwrOEA12Ig9s7u1GGOUjs2p51LY134yZLqb57uenRBv+7gexCWULC3oD0Mhc+a+gzFehkCMkMfvSfvGgrO4JQjFFbTkaPYgA1yuzm6xOMDWzp8qHR9Y2bb+pMQpc0SrszAX9fNkO3BNWHkHWLNhmRMzx+WoiWa0DcPEbsNggUgB/SKcbddWUvkKJJWyOmjbroAge7cAeWVWiROQ47mXlSMssHCYwkyEOmqQlcvO7jOu4uK+LEpCM59rJlhQ84pvzj/WXJ4ozneSYiMlmCdGhGN8JB5deoBBHCcPPdeBeWzjuNJAwkE= Upwork@MELZ-HP-LAPTOP"
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
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.micro"
  key_name = "tdemo1"
  vpc_security_group_ids = [aws_security_group.tdemo-sg.id]

  tags = {
    Name = "Web Server"
    Env = "dev"
    Project = "demo"
  }
}
