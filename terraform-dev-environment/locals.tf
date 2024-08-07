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
  use_spot_instance = false
  g6_48_xlarge_spot = "43"
  spot_price        = local.g6_48_xlarge_spot  # Set your maximum spot price # P5: 42.6818 # G6.48: $2.672, G5.48: $3.8116
  ami               = "ami-08e43e9f9445235ac" # aws-ollama-ami that was built before
  instance_type     = "g6.xlarge" # 4 vCPU, 16 GB RAM, 100 GB SSD / 1GPU L4 24GB (~0.80 p/hour)
#   instance_type     = "g6.12xlarge" # 48 vCPU, 192 GB RAM, 100 GB SSD / 4GPUs L4 96GB (~4.72 p/hour)
#   instance_type     = "g6.48xlarge" # 192 vCPU, 768 GB RAM, 100 GB SSD / 8GPUs L4 192GB (~13.35 p/hour)
#   instance_type     = "p5.48xlarge" # 192 vCPU, 2 TB RAM, 100 GB SSD / 8GPUs H100 640GB (~13.35 p/hour)
}

/*
Amazon EC2 P3 Instances have up to 8 NVIDIA Tesla V100 GPUs. (~12 p/hour)
Amazon EC2 P4 Instances have up to 8 NVIDIA Tesla A100 GPUs. (~32 p/hour)
Amazon EC2 P5 Instances have up to 8 NVIDIA Tesla H100 GPUs. (~98 p/hour)
Amazon EC2 G3 Instances have up to 4 NVIDIA Tesla M60 GPUs.
Amazon EC2 G4 Instances have up to 4 NVIDIA T4 GPUs.
Amazon EC2 G5 Instances have up to 8 NVIDIA A10G GPUs.
Amazon EC2 G6 Instances have up to 8 NVIDIA L4 GPUs.
Amazon EC2 G5g Instances have Arm64-based AWS Graviton2 processors.
 */
