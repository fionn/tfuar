module "database" {
  source = "github.com/fionn/tfuar-modules//modules/data-stores/mysql?ref=v0.0.7"

  db_name     = "prod"
  db_username = "admin"
  db_password = var.db_password
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-tfuar"
    key            = "prod/data-stores/mysql/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
