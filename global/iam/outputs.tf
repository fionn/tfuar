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
