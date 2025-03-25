output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.rds_endpoint
}

output "redis_endpoint" {
  description = "Redis cache endpoint"
  value       = module.redis.redis_endpoint
}

output "ec2_public_ip" {
  description = "Redis cache endpoint"
  value       = module.ec2.public_ip
}
