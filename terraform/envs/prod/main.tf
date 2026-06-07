module "vpc" {
  source = "../../modules/vpc"

  vpc_name    = var.vpc_name
  common_tags = var.common_tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  common_tags        = var.common_tags
}
