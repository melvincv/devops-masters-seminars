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

resource "aws_instance" "myec2" {
   ami = "ami-0b0dcb5067f052a63"
   instance_type = "t2.micro"
   key_name = "tdemo1"
   vpc_security_group_ids  = [aws_security_group.allow_ssh_http.id]

    provisioner "local-exec" {
        command = "echo ${aws_instance.myec2.private_ip} >> private_ips.txt"
    }

   provisioner "remote-exec" {
     inline = [
       "sudo amazon-linux-extras install -y nginx1.12",
       "sudo systemctl start nginx"
     ]

   connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./terraform.pem")
     host = self.public_ip
   }
   }

   provisioner "remote-exec" {
     when = destroy
     on_failure = continue
     inline = [
       "sudo systemctl disable --now nginx"
     ]

   connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./terraform.pem")
     host = self.public_ip
   }
   }
}

resource "aws_key_pair" "tdemo1" {
  key_name   = "tdemo1"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH into VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}