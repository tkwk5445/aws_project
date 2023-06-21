# 다른 저장소에 있는 상태코드를 쓰려고 한다.

data "terraform_remote_state" "aws10_vpc" {
                                 # ▲ 이름 지정해서 이것만 바꿀수있음
  backend = "s3"
  config = {
    bucket = "aws00-terraform-state"
    # ▲ 선생님의 상태코드 파일
    #  ▼ 가지고 와야되는 상태코드 위치 ( 나중에 변수로 지정)
    key    = "infra/network/vpc/terraform.tfstate"
    region = "ap-northeast-2"
  }
}