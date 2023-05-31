provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}


variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["aws10-neo", "aws10-trinity", "aws10-morpheus"]
}

output "all_user" {
  value       = values(aws_iam_user.example)[*].arn
  description = "The Name for all user users"
}

