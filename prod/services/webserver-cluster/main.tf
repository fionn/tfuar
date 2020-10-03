module "webserver_cluster" {
  source = "github.com/fionn/tfuar-modules//services/webserver-cluster?ref=v0.0.6"

  ami         = "ami-06f0013cbb22c8dd3"
  server_text = "foo bar"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "terraform-state-tfuar"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true

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
