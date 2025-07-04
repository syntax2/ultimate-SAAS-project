variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string  
  
}

variable "availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
  
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""
  
}