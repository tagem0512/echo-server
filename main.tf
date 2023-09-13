#################
## √ @devopsengineersam
#################

module "eks_cluster" {
  source = "./eks"
  
  cluster_name         = "Tom-echo-server-cluster"
  region               = "us-east-1"
  vpc_id               = "vpc-0e2192b3a12f1487a"
  public_subnet_ids    = ["subnet-06cf766396bbcac71", "subnet-0ab1047293cda87cb"]
  echo_message         = "Hello Perimeter81"

  owner      = "Nati"
  department = "DevOps"
  temp       = "True"
}