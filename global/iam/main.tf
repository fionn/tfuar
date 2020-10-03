provider "aws" {
  region = "ap-northeast-1"
  version = "~> 3.6.0"
}

variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

output "all_arns" {
  value = aws_iam_user.example[*].arn
  description = "The ARNs for all users"
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-tfuar"
    key            = "global/iam/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
