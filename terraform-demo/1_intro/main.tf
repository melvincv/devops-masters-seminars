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

resource "aws_instance" "webserver" {
  ami           = "ami-09d3b3274b6c5d4aa"
  instance_type = "t3.micro"
  
  tags = {
    Name = "Web Server"
  }
}
