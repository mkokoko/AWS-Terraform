provider "aws" {
  version = "~> 2.44" // Minimal version that supports eks_cluster->vpc_config->public_access_cidrs
  region  = var.aws_region
}

provider "local" {
  version = "~> 1.4"
}
