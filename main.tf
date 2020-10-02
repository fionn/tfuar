locals {
  common_tags = {
    Description = "tfuar-02",
    Env         = "Staging",
    Project     = "tfuar"
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = merge(local.common_tags, { "Name" = "terraform-example" })
}

output "example" {
  description = "Instance IPs and hostname"
  value = {
    "public_ip"  = aws_instance.example.public_ip
    "private_ip" = aws_instance.example.private_ip
    "public_dns" = aws_instance.example.public_dns
  }
}
