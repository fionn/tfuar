module "webserver_cluster" {
  source = "github.com/fionn/tfuar-modules//services/webserver-cluster?ref=v0.0.3"

  cluster_name           = "webservers-staging"
  db_remote_state_bucket = "terraform-state-tfuar"
  db_remote_state_key    = "staging/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = true
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-tfuar"
    key            = "staging/services/webserver-cluster/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
