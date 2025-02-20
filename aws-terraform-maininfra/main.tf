
resource "aws_vpc" "vpc" {
  cidr_block  = "10.7.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    Name = "vpc"
  }
}
resource "aws_subnet" "pub_2a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.7.0.0/20"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "pub-2a"
  }
}
resource "aws_subnet" "pub_2c" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.7.16.0/20"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "pub-2c"
  }
}
resource "aws_subnet" "pvt_2a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.7.32.0/20"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "pvt-2a"
  }
}
resource "aws_subnet" "pvt_2c" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.7.64.0/20"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "pvt-2c"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}


resource "aws_security_group" "sg_eks_cluster" {
  vpc_id = aws_vpc.vpc.id
  name = "eks-cluster-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "eks-cluster-sg"
  }
}

resource "aws_security_group" "sg_jenkins" {
  vpc_id = aws_vpc.vpc.id
  name = "jenkins-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_eip" "jenkins_eip" {
  domain   = "vpc"  # VPC에서 사용
  instance = aws_instance.bastion_jenkins.id
  # vpc = true
  # 태그 설정
  tags = {
    Name = "Terraform-managed Elastic IP for jenkins-bastion"  # 탄력적 IP의 이름 태그
  }
}


resource "aws_eip" "rds_eip" {
  domain   = "vpc"  # VPC에서 사용
  instance = aws_instance.bastion.id
  # vpc = true
  # 태그 설정
  tags = {
    Name = "Terraform-managed Elastic IP for bastion"  # 탄력적 IP의 이름 태그
  }
}