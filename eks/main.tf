#################
## √ @devopsengineersam
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
    Name       = "echo-server-Cluster"
    Owner      = var.owner
    Department = var.department
    Temp       = var.temp
  }

  depends_on = [aws_iam_role_policy_attachment.eks_node_group]
}

# √ Node group
resource "aws_eks_node_group" "main" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "worker-nodes"
  instance_types  = [var.node_instance_type]
  subnet_ids      = var.public_subnet_ids
  node_role_arn   = aws_iam_role.eks_node_group.arn

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }
  tags = {
    Name       = "echo-server-Node"
    Owner      = var.owner
    Department = var.department
    Temp       = var.temp
  }
}

# √ Node Role
resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group-role"
  tags = {
    Name       = "echo-server-Role"
    Owner      = var.owner
    Department = var.department
    Temp       = var.temp
  }
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_group" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_node_group_ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
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
