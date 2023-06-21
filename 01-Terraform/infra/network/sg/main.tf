# 디폴트 보안 그룹

/* resource "aws_default_security_group" "aws10-default-sg" {
   #디렉토리가 다르니까 공유가 안 됨
  # 선생님의 vpc 상태 코드를 받아와야 함 (remote.tf에서) 
  vpc_id = data.terraform_remote_state.aws10_vpc.outputs.vpc_id
                                         # ▲ 이름 지정 해서 이것만 바꿀수있음              

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = [data.terraform_remote_state.aws10_vpc.outputs.vpc_cidr]
    # 선생님의 vpc 상태 코드를 받아와야 함 (remote.tf에서) 
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "aws10-default_sg"
    Description = "default security group"
  }
} */

# SSH Security Group
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

# WEB Security Group
resource "aws_security_group" "aws10-web-sg" {
  # 디렉토리가 다르니까 공유가 안 됨
  # 선생님의 vpc 상태 코드를 받아와야 함 (remote.tf에서) 
  name        = "aws10_web_sg"
  description = "security group for web server"
  vpc_id      = data.terraform_remote_state.aws10_vpc.outputs.vpc_id
                                               # ▲ 이름 지정 해서 이것만 바꿀수있음              


  ingress {
    description = "For web port"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws10_web_sg"
  }
}