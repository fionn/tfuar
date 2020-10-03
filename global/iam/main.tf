provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 3.6.0"
}

variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}

output "all_arns" {
  value       = values(aws_iam_user.example)[*].arn
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
