data "aws_availability_zones" "available" { # data.aws_availability_zones.available.
  state = "available"
}

data "aws_ami" "eks_bastion_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["eks-bastion"]
  }

  owners = ["self"]
}



data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}
