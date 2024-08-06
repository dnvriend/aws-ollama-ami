locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# variables
variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# builder configuration
source "amazon-ebs" "aws_ollama_ami" {
  skip_create_ami             = false
  ami_name                    = "aws-ollama-ami-${local.timestamp}"
  instance_type               = "g6.xlarge" # 4 vCPU, 16 GB RAM, 100 GB SSD / NVIDIA A10G 24GB
  region                      = "us-east-1"
  source_ami                  = "ami-0789254dc85327667"
  ssh_username                = "ec2-user"
  vpc_id                      = var.vpc_id
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
}

# build runs
build {
  name = "build-aws-ollama-ami"
  sources = [
    "source.amazon-ebs.aws_ollama_ami"
  ]

  # run scripts on the instance
  provisioner "shell" {
    script = "install-ollama.sh"
  }
}
