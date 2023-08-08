#################
## √ @Tom
#################

provider "aws" {
  region = var.region
}

#######
## Use existing VPC and public subnets
######

#EKS module
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  subnet_ids      = var.public_subnet_ids  # Use the variable to receive the existing public subnets IDs
  vpc_id          = var.vpc_id  # Use the variable to receive the existing VPC ID

  tags = {
    Name       = "Tom EKS Cluster"
    Owner      = var.owner
    Department = var.department
    Temp       = var.temp
  }
}

# √ Trigger the helm job to run on the EKS cluster from the local

resource "null_resource" "trigger_helm" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./helm-job.yaml"
    working_dir = "../"
  }

  depends_on = [module.eks] # √ will wait for the EKS module to be provisioned before running the helm trigger
}
#######
## Provision new VPC and subnets
######

# resource "aws_vpc" "eks_vpc" {
#   cidr_block = var.vpc_cidr
#   tags = {
#     Name       = "Tom VPC for ${var.cluster_name}"
#     Owner      = var.owner
#     Department = var.department
#     Temp       = var.temp
#   }
# }

# resource "aws_subnet" "public" {
#   count = length(var.public_subnets_cidrs)
#   cidr_block = var.public_subnets_cidrs[count.index]
#   vpc_id     = aws_vpc.eks_vpc.id
#   tags = {
#     Name       = "Tom Public Subnet ${count.index}"
#     Owner      = var.owner
#     Department = var.department
#     Temp       = var.temp
#   }
# }

# output "kubeconfig" {
#   value = module.eks.kubeconfig_filename
# }

# output "echo_server_url" {
#   value = module.eks.load_balancer_address
# }
