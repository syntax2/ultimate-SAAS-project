variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string  
  
}

variable "availability_zones" {
  description = "List of availability zones for the VPC"
  type        = list(string)
  
}