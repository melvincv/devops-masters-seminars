variable "region" {
  default = "us-east-1"
}

variable "tags" {
  type = list
  default = ["webserver","dbserver"]
}

variable "ami" {
  type = map
  default = {
    "us-east-1" = "ami-0323c3dd2da7fb37d"
    "us-west-2" = "ami-0d6621c01e8c2de2c"
    "ap-south-1" = "ami-0470e33cd681b2476"
    "ap-southeast-1" = "ami-094bbd9e922dc515d"
  }
}

