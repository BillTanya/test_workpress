variable "private_subnet_ids" {}
variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "db_name" {}
variable "rds_user_name" {}
variable "rds_password" {}

variable "sg_rds_name" {
  description = "RDS MySQL name"
  type        = string
  default     = "sg-rds"
}

variable "rds_subnet_group_name" {
  description = "RDS subnet group name"
  type        = string
  default     = "rds-subnet-group"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_name" {
  description = "RDS instance class"
  type        = string
  default     = "wordpress-rds"
}
