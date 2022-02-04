variable "aws_region" {
  default = "us-west-1" #may need to change when network layer is modularized
}

variable "web_instance" {
  default = "t2.micro"
}

variable "db_instance" {
  default = "t2.micro"
}
