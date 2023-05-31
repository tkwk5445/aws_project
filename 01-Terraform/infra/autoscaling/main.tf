provider "aws" {
  region = "ap-northeast-2"
}
# AWS 시작구성

resource "aws_launch_template" "example" {
  name                   = "aws10-example"
  image_id               = "ami-0ab04b3ccbadfae1f"
  instance_type          = "t2.micro"
  key_name               = "aws10-key"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = base64encode(data.template_file.web_output.rendered)
  lifecycle {
    create_before_destroy = true
  }
}

# AWS autoscaling group create
resource "aws_autoscaling_group" "example" {
  # 가용영역 지정
  # availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
  # subnet 지정 
  vpc_zone_identifier = [var.subnet_public_1, var.subnet_public_2]

  name             = "aws10-terraform-asg-example"
  desired_capacity = 1
  min_size         = 1
  max_size         = 2

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "aws10-terraform-asg-example"
    propagate_at_launch = true
  }
}

# instance 보안그룹 생성
resource "aws_security_group" "instance" {
  name   = "aws10-terraform-example-instance"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "vpc_id" {
  default = "<vpc-id>"
}

variable "subnet_public_1" {
  default = "<subnet-id>"
}

variable "subnet_public_2" {
  default = "<subnet-id>"
}

variable "server_port" {
  description = "The  port will use for HTTP request..! Ex) 8080"
  type        = number
  default     = 8080
}

data "template_file" "web_output" {
  template = file("${path.module}/web.sh")
  vars = {
    server_port = "${var.server_port}"
  }
}
