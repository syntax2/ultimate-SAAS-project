variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be created"
  type        = string
  
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
  
}

variable "node_groups" {
  description = "Map of node group configurations"
  type        = map(object({
    instance_type = string
    desired_size  = number
    max_size      = number
    min_size      = number
    key_name      = string
  }))
  default     = {}
  
}