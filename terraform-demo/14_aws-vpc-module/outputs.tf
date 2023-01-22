output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}