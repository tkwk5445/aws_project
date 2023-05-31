provider "aws" {
  region = "ap-northeast-2"
}
# AWS 시작구성

resource "aws_launch_configuration" "example" {
  image_id        = "ami-0ab04b3ccbadfae1f"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data       = <<-EOF
								#!/bin/bash
								echo "Hello, World" > index.html
								nohup busybox httpd -f -p ${var.server_port} &
								EOF
  lifecycle {
    create_before_destroy = true
  }
}

# AWS autoscaling group create
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids
  min_size             = 1
  max_size             = 2

  tag {
    key                 = "Name"
    value               = "aws10-terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
	vpc_id = data.aws_vpc.default.id
  name = "aws10-terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["604-vpc"]
  }
}


data "aws_subnets" "default" {
	filter {
		name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

variable "server_port" {
  description = "The  port will use for HTTP request..! Ex) 8080"
  type        = number
  default     = 8080
}
