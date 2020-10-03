provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 3.6.0"
}

variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

variable "hero_thousand_faces" {
  description = "map"
  type        = map(string)
  default = {
    neo      = "hero"
    trinity  = "love interest"
    morpheus = "mentor"
  }
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}

output "all_arns" {
  value       = values(aws_iam_user.example)[*].arn
  description = "The ARNs for all users"
}

output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
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
