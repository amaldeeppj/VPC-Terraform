# AWS VPC Terraform module

Terraform module which creates VPC resources on AWS.



## Usage 

```

```


## Requirements

Name | Version
--- | ---
Terraform | >= v1.3.6
AWS | >= v4.48.0



## Resources

* aws_vpc
* aws_internet_gateway
* aws_subnet
* aws_subnet
* aws_eip
* aws_nat_gateway
* aws_route_table
* aws_route_table



# Argument Reference

* common_name_tag
* common_tags
* vpc_cidr
* public_subnet_names
* public_subnet_cidr
* public_subnet_azs
* private_subnet_names
* private_subnet_cidr
* private_subnet_azs



# Attributes Reference

* vpc_id
* public_subnets
* private_subnets

