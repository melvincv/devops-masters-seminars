resource "aws_instance" "webserver" {
  ami           = "ami-0b0dcb5067f052a63"  # Amazon Linux 2
  instance_type = "t3.micro"
  key_name = "tdemo1"
  vpc_security_group_ids = [aws_security_group.tdemo-sg.id]

  tags = {
    Name = "Web Server"
    Env = "dev"
    Project = "demo"
  }
}
