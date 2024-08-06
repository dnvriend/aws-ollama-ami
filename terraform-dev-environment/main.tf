resource "aws_iam_instance_profile" "instance" {
  name_prefix = local.name
  role = aws_iam_role.instance.name
}

resource "aws_iam_role" "instance" {
  name_prefix = local.name

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
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

resource "aws_instance" "instance_a" {
  ami                         = local.ami
  associate_public_ip_address = true
  availability_zone           = "${local.region}a"
  instance_type               = local.instance_type
  key_name                    = local.key_name
  subnet_id                   = local.subnet_public_1a
  vpc_security_group_ids      = [aws_security_group.sg.id]
  iam_instance_profile        = aws_iam_instance_profile.instance.name

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 500
    iops                  = 3000
    throughput            = 250
    volume_type           = "gp3"
  }

  tags = {
    Name        = local.name
  }
}

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

#   lifecycle {
#     create_before_destroy = true
#   }
}

output "public-ip-instance-a" {
  value = aws_instance.instance_a.public_ip
}

output "key_name" {
  value = local.key_name
}

output "ssh_command" {
  value = "ssh ec2-user@${aws_instance.instance_a.public_ip} -i ~/.ssh/${local.key_name}.pem"
}
