terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }

    aap = {
      source = "ansible/aap"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
}

# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "tf-demo-aws-ec2-instance-1" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = "t2.micro"
  tags = {
    Name = "tf-demo-aws-ec2-instance-1"
  }
}

resource "aws_instance" "tf-demo-aws-ec2-instance-2" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = "t2.micro"
  tags = {
    Name = "tf-demo-aws-ec2-instance-2"
  }
}

provider "awx" {
  endpoint     = "https://control"
  token        = ""
  platform     ="awx"
  insecure     = true
  
  api_retry = {
    api_retry_count   = 3
    api_retry_delay_seconds = 2
  }
}

resource "aap_host" "tf-demo-aws-ec2-instance-2" {
  inventory_id = 2
  name = "aws_instance_tf-demo-aws-ec2-instance-2"
  description = "An EC2 instance created by Terraform"
  variables = jsonencode(aws_instance.tf-demo-aws-ec2-instance-2)
}
