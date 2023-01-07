output "availability_zones_count" {
    description = "Number of availability zones in specified region"
    value = length(data.aws_availability_zones.available.names)
}

output "vpc_id" {
    description = "VPC id"
    value = aws_vpc.vpc.id 
}

output "public_subnets" {
    value = aws_subnet.public[*].id
  
}

output "private_subnets" {
    value = aws_subnet.private[*].id
  
}

# output "public_subnets" {
#     value = [ for subnet in aws_subnet.public: subnet.id ]
  
# }

# output "private_subnets" {
#     value = [ for subnet in aws_subnet.private: subnet.id ]
  
# }