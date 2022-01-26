provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}
data "aws_ami" "amazon_linux_2" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}


resource "aws_launch_configuration" "web_lc" {
  name          = "web_launch_config"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.web_instance
  #security_group = grab from modularized network layer
  #user_data = file("user_data.sh")

  lifecycle_rule {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                 = "web_autoscaling_group"
  launch_configuration = aws_launch_configuration.web_ls.name
  min_size             = 2
  max_size             = 5
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  #load_balancers =
  #vpc_zone_identifier =
  lifecycle_rule {
    create_before_destroy = true
  }
}

resource "aws_elb" "web_elb" {
  name = "web_elb"
  availability_zones =
  security_groups =
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 1
    timeout = 10
    target = "HTTP:80/"
    interval = 30
  }
}
