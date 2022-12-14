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

locals {
  common_tags = {
    Name = "localdev"
    Owner = "Melvin"
    service = "web"
  }
}

resource "aws_instance" "webserver-dev" {
  ami           = "ami-09d3b3274b6c5d4aa"
  instance_type = "t3.nano"
  availability_zone = "us-east-1a"
  key_name = "tdemo1"
  vpc_security_group_ids = [aws_security_group.tdemo-sg.id]
  tags = local.common_tags
}

resource "aws_instance" "webserver-stg" {
  ami           = "ami-09d3b3274b6c5d4aa"
  instance_type = "t3.micro"
  availability_zone = "us-east-1b"
  key_name = "tdemo1"
  vpc_security_group_ids = [aws_security_group.tdemo-sg.id]
  tags = local.common_tags
}

resource "aws_ebs_volume" "dev_ebs" {
  availability_zone = "us-east-1a"
  size              = 8
  tags = local.common_tags
}