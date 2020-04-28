resource "aws_iam_role" "cluster_role" {
  name = "${var.eks_name}-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_security_group" "eks-cluster" {
  name        = "${var.eks_name}-cluster-sg"
  description = "Cluster communications with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.eks_name}-cluster-sg"
  }
}

resource "aws_eks_cluster" "eks" {
  name     = var.eks_name
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.eks_version

  vpc_config {
    endpoint_public_access  = true // default value
    endpoint_private_access = true // Enabled to allow worker nodes connections to cluster when "vpc_config->public_access_cidrs" is set to non-default value

    subnet_ids          = var.public_subnet_ids
    security_group_ids  = [aws_security_group.eks-cluster.id]
    public_access_cidrs = var.eks_cluster_public_access_cidrs 
  }


  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}
