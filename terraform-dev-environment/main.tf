# Existing IAM resources remain unchanged
resource "aws_iam_instance_profile" "instance" {
  name_prefix = local.name
  role        = aws_iam_role.instance.name
}

resource "aws_iam_role" "instance" {
  name_prefix = local.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    data.aws_iam_policy.aws_ssm_managed_instance_core.arn,
    data.aws_iam_policy.aws_cloudwatch_agent_server_policy.arn,
    data.aws_iam_policy.aws_administrator_access.arn,
  ]
}

# Spot instance resource
resource "aws_spot_instance_request" "instance_a" {
  count = local.use_spot_instance ? 1 : 0

  ami                         = local.ami
  instance_type               = local.instance_type
  key_name                    = local.key_name
  vpc_security_group_ids      = [aws_security_group.sg.id]
  iam_instance_profile        = aws_iam_instance_profile.instance.name
  subnet_id                   = local.subnet_public_1a
  associate_public_ip_address = true
  availability_zone           = "${local.region}a"

  spot_type            = "persistent"
  spot_price           = local.spot_price
  wait_for_fulfillment = true

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 500
    iops                  = 3000
    throughput            = 250
    volume_type           = "gp3"
  }

  tags = {
    Name = "${local.name}-spot"
  }
}

# On-demand instance resource
resource "aws_instance" "instance_a" {
  count = local.use_spot_instance ? 0 : 1

  ami                         = local.ami
  instance_type               = local.instance_type
  key_name                    = local.key_name
  vpc_security_group_ids      = [aws_security_group.sg.id]
  iam_instance_profile        = aws_iam_instance_profile.instance.name
  subnet_id                   = local.subnet_public_1a
  associate_public_ip_address = true
  availability_zone           = "${local.region}a"

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 500
    iops                  = 3000
    throughput            = 250
    volume_type           = "gp3"
  }

  tags = {
    Name = "${local.name}-ondemand"
  }
}

# The security group remains unchanged
resource "aws_security_group" "sg" {
  name        = local.name
  description = local.name
  vpc_id      = local.vpc_id

  egress {
    description = "allow-all"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    description = "allow-ssh"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    description = "allow-http"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
}

# Update outputs to use either spot or on-demand instance
output "public-ip-instance-a" {
  value = local.use_spot_instance ? aws_spot_instance_request.instance_a[0].public_ip : aws_instance.instance_a[0].public_ip
}

output "key_name" {
  value = local.key_name
}

output "ssh_command" {
  value = "ssh ec2-user@${local.use_spot_instance ? aws_spot_instance_request.instance_a[0].public_ip : aws_instance.instance_a[0].public_ip} -i ~/.ssh/${local.key_name}.pem"
}