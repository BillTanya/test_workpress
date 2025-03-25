variable "private_subnet_ids" {}
variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "cluster_id" {}

variable "sg_redis_name" {
  description = "Redis ElastiCache name"
  type        = string
  default     = "sg-redis"
}

variable "node_type" {
  description = "Redis node type id"
  type        = string
  default     = "cache.t3.micro"
}
