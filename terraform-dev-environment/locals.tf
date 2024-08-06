variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

locals {
  # network
  vpc_id            = var.vpc_id
  subnet_public_1a  = var.subnet_id
  key_name          = var.key_name
  region            = "us-east-1"
  name              = "aws-ollama-test"
  ami               = "ami-08e43e9f9445235ac" # aws-ollama-ami that was built before
#   instance_type     = "g6.xlarge" # 4 vCPU, 16 GB RAM, 100 GB SSD / 1GPU (~0.80 p/hour)
  instance_type     = "g6.12xlarge" # 48 vCPU, 192 GB RAM, 100 GB SSD / 4GPUs (~4.72 p/hour)
#   instance_type     = "g6.48xlarge" # 192 vCPU, 192 GB RAM, 100 GB SSD / 8GPUs (~13.35 p/hour)
}
