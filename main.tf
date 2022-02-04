provider "aws" {
  region = var.aws_region
}

module "network_stack" {
  source = "./Modules/Network"
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

data "aws_ami" "amazon_linux_2" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}
#-------------------------------------------------------------------------------
resource "aws_launch_configuration" "web_lc" {
  name            = "web_launch_config"
  image_id        = data.aws_ami.amazon_linux_2.id
  instance_type   = var.web_instance
  security_groups = module.network_stack.web_sg_id
  #user_data = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                 = "web_autoscaling_group"
  launch_configuration = aws_launch_configuration.web_lc.name
  min_size             = 2
  max_size             = 5
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  load_balancers       = aws_elb.web_elb.name
  vpc_zone_identifier  = module.network_stack.public_subnet_ids
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web_elb" {
  name               = "web-elb"
  availability_zones = module.network_stack.availability_zones
  security_groups    = [module.network_stack.web_sg_id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    target              = "HTTP:80/"
    interval            = 30
  }
}
