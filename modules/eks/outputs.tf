output "eks-endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_security_group_ids" {
  value = aws_eks_cluster.eks.vpc_config.*.cluster_security_group_id
}

locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.eks_name}"
KUBECONFIG

  configmap_aws_auth = templatefile("${path.module}/templates/configmap-aws-auth.yaml.tpl", {})
}

resource "local_file" "eks-kubeconfig" {
  content         = local.kubeconfig
  filename        = "eks-kubeconfig"
  file_permission = "600"
}

resource "local_file" "configmap_aws_auth" {
  content         = local.configmap_aws_auth
  filename        = "configmap-aws-auth.yaml"
  file_permission = "600"

  provisioner "local-exec" {
    command = "KUBECONFIG='./eks-kubeconfig' kubectl apply -f configmap-aws-auth.yaml"
  }

  depends_on = [local_file.eks-kubeconfig]
}
