terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "eks-cluster/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = "10.0.0.0/16"
  subnet_a_cidr = "10.0.1.0/24"
  subnet_b_cidr = "10.0.2.0/24"
}

module "iam" {
  source = "./modules/iam"
}

module "eks_cluster" {
  source            = "./modules/eks-cluster"
  cluster_name      = "my-eks-cluster"
  cluster_role_arn  = module.iam.eks_cluster_role_arn
  subnet_ids        = module.vpc.subnet_ids
  security_group_id = module.vpc.eks_sg.id
}


output "eks_cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "eks_cluster_certificate_authority" {
  value = module.eks_cluster.cluster_certificate_authority
}
