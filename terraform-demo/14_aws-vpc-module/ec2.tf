module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "demo-instance"

  ami                    = "ami-0b5eea76982371e91"
  instance_type          = "t2.micro"
  key_name               = "tdemo1"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.tdemo-sg.id]
  subnet_id              = module.vpc.public_subnets[1]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_key_pair" "tdemo1" {
  key_name   = "tdemo1"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_security_group" "tdemo-sg" {
  name        = "tdemo-sg"
  description = "Allow SSH and HTTP"
  vpc_id = module.vpc.vpc_id

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
