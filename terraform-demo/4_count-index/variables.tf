variable "instance_type" {
  default = "t3.micro"
  type = string
}

variable "ami_id" {
  default = "ami-09d3b3274b6c5d4aa"
  type = string
}

variable "alb_names" {
  default = ["dev-alb", "stg-alb", "prod-alb"]
  type = list
}

variable "env" {
  default = ["dev", "stg", "prod"]
  type = list
}
