resource "aws_db_instance" "wordpressdb" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = var.instance_class
  db_name              = var.db_name
  username             = var.rds_user_name
  password             = var.rds_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible  = false
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  tags = {
    Name = var.rds_name
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.rds_subnet_group_name
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = var.rds_subnet_group_name
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.sg_rds_name
  }

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }
}
