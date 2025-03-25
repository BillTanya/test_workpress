module "vpc" {
  source              = "./modules/vpc"
}

module "rds" {
  source             = "./modules/rds"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = module.vpc.vpc_cidr_block
  rds_user_name      = var.RDS_USER_NAME
  rds_password       = var.RDS_PASSWORD
  db_name            = var.DB_NAME
}

module "redis" {
  source             = "./modules/redis"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = module.vpc.vpc_cidr_block
  cluster_id         = var.REDIS_CLUSTER_ID
}

module "ec2" {
  source           = "./modules/ec2"
  public_subnet_id = module.vpc.public_subnet_id
  vpc_id           = module.vpc.vpc_id
  rds_sg_id        = module.rds.rds_sg_id
  redis_sg_id      = module.redis.redis_sg_id
  key_pair_name    = var.KEY_PAIR_NAME
}
