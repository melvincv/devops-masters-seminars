output "instance_ip_public" {
  value = aws_instance.webserver.public_ip
}

output "instance_ip_private" {
  value = aws_instance.webserver.private_ip
}

output "instance_id" {
  value = aws_instance.webserver.id
}
