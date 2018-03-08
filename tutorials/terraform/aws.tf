provider "aws" {
  region     = "us-east-2" # Ohio
}

resource "aws_instance" "t2_terraform_starter" {
  ami           = "ami-965e6bf3" # 2018-03-07 Ubuntu 16.04 LTS
  instance_type = "t2.micro"
  key_name      = "aws-yeukhon-ec2"
  subnet_id     = "subnet-b30fb9db" # private-2a
  vpc_security_group_ids = ["sg-10e2567b"]  # security-groups is for classic
  tags          = {
    Name = "t2_terraform_starter"
  }
}

resource "aws_security_group" "allow_ssh_22" {
  name        = "allow_ssh_22"
  description = "Allow SSH"
  vpc_id      = "vpc-2aeb5f42"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

