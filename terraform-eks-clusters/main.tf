module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = var.project_name
  vpc_additional_tags = map(
    "kubernetes.io/cluster/${var.project_name}-${var.eks_cluster_name}", "shared"
  )
}

module "subnets" {
  source                  = "../modules/subnets"
  vpc_id                  = module.vpc.out_vpc_id
  vpc_private_subnets     = var.vpc_private_subnets
  vpc_private_subnet_name = ["${var.project_name}-private-1", "${var.project_name}-private-2"]
  private_subnet_type     = "private"
  igw_name                = "${var.project_name}-igw"
  vpc_public_subnets      = var.vpc_public_subnets
  vpc_public_subnet_name  = ["${var.project_name}-public-1", "${var.project_name}-public-2"]
  public_subnet_type      = "public"
  vpc_name                = module.vpc.out_vpc_name
  availability_zone       = var.availability_zone

  public_subnet_additional_tags = map(
    "kubernetes.io/cluster/${var.project_name}-${var.eks_cluster_name}", "shared"
  )

  private_subnet_additional_tags = map(
    "kubernetes.io/cluster/${var.project_name}-${var.eks_cluster_name}", "shared"
  )
}

module "eks" {
  source             = "../modules/eks"
  eks_name           = "${var.project_name}-${var.eks_cluster_name}"
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  vpc_id             = module.vpc.out_vpc_id

  default_node_group_instance_type = "t3.medium"
  default_node_group_min_size      = 3
  default_node_group_max_size      = 5
  default_node_group_desired_size  = 3

  eks_cluster_public_access_cidrs = [  //If needed to restrict access to EKS put ip here 
    "8.8.8.8/32",  // Some Sample
  ]
}

module "rds" {
  source               = "../modules/rds"
  environment          = "${var.project_name}-dev"
  allocated_storage    = "20"
  database_name        = var.database_name
  database_username    = var.database_username
  database_password    = var.database_password
  db_subnet_group_name = "${var.project_name}-private-1"
  subnet_ids           = module.subnets.private_subnet_ids
  vpc_id               = module.vpc.out_vpc_id
  instance_class       = "db.t3.micro"

  ingress_security_group_ids = module.eks.cluster_security_group_ids
}

module "redis" {
  source      = "../modules/aws-elasticache-redis"
  name        = "${var.project_name}-${var.redis_cluster_name}"
  vpc_id      = module.vpc.out_vpc_id
  subnet_ids  = module.subnets.private_subnet_ids
  environment = "${var.project_name}-${var.redis_cluster_name}"

  ingress_security_group_ids = module.eks.cluster_security_group_ids
}
