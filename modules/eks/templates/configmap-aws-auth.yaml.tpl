apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::589295909756:role/worker-nodes-role
      username: system:node:{{EC2PrivateDNSName}}
      groups:
      - system:bootstrappers
      - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::589295909756:user/mkrtich
      username: mkrtich
      groups:
        - system:masters
    - userarn: arn:aws:iam::589295909756:user/asitnik
      username: asitnik
      groups:
        - system:masters
