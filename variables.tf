variable "common_name_tag" {
    type = string
    description = "Common name tag to identify resources"
  
}

variable "common_tags" {
    type = map(string)
    description = "Common tags for resources"
    default = {}
  
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"

}

variable "public_subnet_names" {
    type = list(string)
    description = "Name list for public subnets"
  
}

variable "public_subnet_cidr" {
    type = list(string)
    description = "CIDR list for public subnets"
  
}

variable "public_subnet_azs" {
    type = list(string)
    description = "CIDR list for public subnets"
  
}

variable "private_subnet_names" {
    type = list(string)
    description = "Name list for public subnets"
  
}

variable "private_subnet_cidr" {
    type = list(string)
    description = "CIDR list for public subnets"
  
}

variable "private_subnet_azs" {
    type = list(string)
    description = "CIDR list for public subnets"
  
}