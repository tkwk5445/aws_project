# cidr
variable "vpc_cidr" {
    default = "10.10.0.0/16"
}

# 퍼블릭 서브넷
variable "public_subnet" {
    type = list
    default = ["10.10.0.0/24", "10.10.16.0/24"]
}

# 프라이빗 서브넷
variable "private_subnet" {
    type = list
    default = ["10.10.64.0/24", "10.10.80.0/24"]
}

# 가용영역
variable "azs" {
    type = list
    default = ["ap-northeast-2a", "ap-northeast-2c"]
}
