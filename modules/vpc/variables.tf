variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "wordpress-vpc"
}

variable "public_subnet_name" {
  description = "Public subnet name"
  type        = string
  default     = "public"
}

variable "privat_subnet_name" {
  description = "Privat subnet name"
  type        = string
  default     = "privat"
}
