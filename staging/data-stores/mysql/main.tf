resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-running-"
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "example_database"
  username          = "admin"

  # https://github.com/terraform-providers/terraform-provider-aws/issues/2588
  skip_final_snapshot = true

  password = var.db_password
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-tfuar"
    key            = "staging/data-stores/mysql/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
