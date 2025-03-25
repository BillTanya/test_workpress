resource "aws_elasticache_subnet_group" "redis_subnet" {
  name = "redis-subnet"
  subnet_ids = [var.private_subnet_ids[1]]
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id        = var.cluster_id
  engine            = "redis"
  node_type         = var.node_type
  num_cache_nodes   = 1
  subnet_group_name = aws_elasticache_subnet_group.redis_subnet.name
  security_group_ids = [aws_security_group.redis_sg.id]
}

resource "aws_security_group" "redis_sg" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.sg_redis_name
  }

  ingress {
    from_port = 6379
    to_port   = 6379
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