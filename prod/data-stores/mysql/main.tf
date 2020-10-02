module "database" {
  source = "../../../modules/data-stores/mysql"

  db_name     = "prod"
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
