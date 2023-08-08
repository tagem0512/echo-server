#################
## √ @Tom
#################

variable "cluster_name" {
  description = "The name of the EKS cluster."
  default     = "Tom-Agembo-echo-server"  
}

variable "region" {
  description = "The AWS region where the resources will be created."
  default     = "us-east-1" 
}

#######
## Use existing VPC and public subnets
######

variable "public_subnet_ids" {
  description = "A list of subnet IDs to associate with the EKS cluster."
  type        = list(string)
  default     = ["subnet-06cf766396bbcac71", "subnet-0ab1047293cda87cb"]
}

variable "vpc_id" {
  description = "The CIDR block for the VPC."
  default     = "vpc-0e2192b3a12f1487a"
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS nodes"
  default = ["t3.medium"]
}

variable "echo_message" {
  description = "The message that the echo server will echo."
  default     = "Hello Perimeter81"
}

variable "owner" {
  description = "Owner tag value."
  default =   "Nati"
}

variable "department" {
  description = "Department tag value."
  default = "DevOps"
}

variable "temp" {
  description = "Temp tag value."
  default = "True"
}

#######
## Provision new VPC and subnets
######

# variable "subnets" {
#   description = "A list of subnet IDs to associate with the EKS cluster."
#   default     = ["subnet-53eea109", "subnet-c8b0ad80"] 
# }

# variable "vpc_cidr" {
#   description = "The CIDR block for the VPC."
#   default     = "10.0.0.0/16"
# }

# variable "public_subnets_cidrs" {
#   description = "A list of CIDR blocks for the public subnets."
#   default = ["10.0.4.0/24", "10.0.5.0/24" ]
# }
