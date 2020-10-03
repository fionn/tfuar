module "hello_world_app" {
  source = "github.com/fionn/tfuar-modules//modules/services/hello-world-app?ref=v0.0.7"

  server_text            = "New server text"
  environment            = "staging"
  db_remote_state_bucket = "terraform-state-tfuar"
  db_remote_state_key    = "staging/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-tfuar"
    key            = "staging/services/hello-world-app/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
