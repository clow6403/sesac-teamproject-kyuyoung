resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = file("/key.pub")
}


resource "aws_instance" "bastion_jenkins" {
  # iam_instance_profile   = aws_iam_instance_profile.ec2_kms_profile.name
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.sg_jenkins.id]
  subnet_id              = aws_subnet.pub_2a.id

  key_name = aws_key_pair.key.key_name

  source_dest_check = false

  root_block_device {
    volume_size = 20 
    volume_type = "gp3"
  } # 루트 블록 스토리지 용량 추가

  tags = {
    Name = "bastion-jenkins"
  }
}


resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.eks_bastion_ami.id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.sg_eks_cluster.id]
  subnet_id              = aws_subnet.pub_2a.id
  key_name               = aws_key_pair.key.key_name
  source_dest_check      = false

  user_data = <<-EOF
              #cloud-boothook
              #!/bin/bash
              timedatectl set-timezone Asia/Seoul
              sudo dnf install postgresql15 -y
              EOF

  tags = {
    Name = "bastion"
  }
}
