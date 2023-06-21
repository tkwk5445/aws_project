terraform {
  backend "s3" {
    # 이전에 생성한 버킷 이름으로 변경
    bucket = "aws10-terraform-state"
    key    = "infra/network/sg/terraform.tfstate"
    region = "ap-northeast-2"

    # 이전에 생성한 Dynamodb 테이블 이름으로 변경
    dynamodb_table = "aws10-terraform-locks"
    encrypt        = true
  }
}