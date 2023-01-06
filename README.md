# AWS VPC Terraform module

Terraform module which creates VPC resources on AWS.



## Usage 

```

module "vpc" {
    source = "github.com/amaldeeppj/VPC-Terraform.git"

    common_name_tag = new-project
    vpc_cidr = "172.16.0.0/16"
    public_subnet_names = ["public-1", "public-2", "public-3"]
    public_subnet_cidr = ["172.16.0.0/20", "172.16.16.0/20", "172.16.32.0/20"]
    public_subnet_azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    private_subnet_names = ["private-1", "private-2", "private-3"]
    private_subnet_cidr = ["172.16.48.0/20", "172.16.64.0/20", "172.16.80.0/20"] 
    private_subnet_azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

    common_tags = {
        env = dev
    }
}

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



## Argument Reference

* common_name_tag
* common_tags
* vpc_cidr
* public_subnet_names
* public_subnet_cidr
* public_subnet_azs
* private_subnet_names
* private_subnet_cidr
* private_subnet_azs



## Attributes Reference

* vpc_id
* public_subnets
* private_subnets

