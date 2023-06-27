resource "aws_instance" "aws10_bastion" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  key_name      = "aws10-key"
  # 보안그룹
  vpc_security_group_ids = [aws_security_group.aws10-ssh-sg.id]
  # 서브넷
  subnet_id = data.terraform_remote_state.aws10_vpc.outputs.public_subnet2a
  # 가용영역
  availability_zone = "ap-northeast-2a"
  # 퍼블릭 ip 자동 할당 여부
  associate_public_ip_address = true
  tags = {
    Name = "aws10_bastion"
  }
}

resource "aws_security_group" "aws10-ssh-sg" {
  name        = "aws10_ssh_sg"
  description = "security group for ssh server"
  vpc_id      = data.terraform_remote_state.aws10_vpc.outputs.vpc_id
                                                 # ▲ 이름 지정 해서 이것만 바꿀수있음              


  ingress {
    description = "For ssh port"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws10_ssh_sg"
  }
}
