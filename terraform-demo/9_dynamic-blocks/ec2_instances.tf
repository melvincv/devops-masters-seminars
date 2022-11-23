resource "aws_instance" "webserver" {
  ami           = "ami-09d3b3274b6c5d4aa"
  instance_type = "t3.micro"
  key_name = "tdemo1"
  vpc_security_group_ids = [aws_security_group.tdemo-sg.id]

  tags = {
    Name = "Web Server"
    Env = "dev"
    Project = "demo"
  }
}
