module "webserver_cluster" {
  source = "github.com/fionn/tfuar-modules//services/webserver-cluster?ref=v0.0.5"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-state-tfuar"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type        = "t2.micro"
  min_size             = 2
  max_size             = 10
  enable_autoscaling   = true
  enable_new_user_data = false

  custom_tags = {
    Owner      = "team-foo"
    DeployedBy = "terraform"
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-tfuar"
    key            = "prod/services/webserver-cluster/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
