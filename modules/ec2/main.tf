# modules/security_groups/main.tf
resource "aws_instance" "wordpress" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  security_groups = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name

  tags = {
    Name = var.instance_name
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2 php php-mysql mysql-client php-redis
    sudo apt install -y wget curl php-cli php-mbstring git unzip
    systemctl start apache2
    systemctl enable apache2
  EOF
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.sg_ec2_name
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [var.rds_sg_id]
  }

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    security_groups = [var.redis_sg_id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
