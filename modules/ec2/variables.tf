variable "public_subnet_id" {}
variable "vpc_id" {}
variable "rds_sg_id" {}
variable "redis_sg_id" {}
variable "key_pair_name" {}

variable "sg_ec2_name" {
  description = "Instance name"
  type        = string
  default     = "sg-ec2"
}

variable "ami" {
  description = "Ami id"
  type        = string
  default     = "ami-0df368112825f8d8f"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Instance name"
  type        = string
  default     = "wordpress-ec2"
}
