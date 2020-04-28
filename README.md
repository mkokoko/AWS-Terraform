# Usage

## AWS Credentials setup
This Terraform configuration relies on AWS credentials set in your environment instead of adding API keys to its configuration files.
You may either:
1. Setup default credentials for your user with `aws configure` command
2. Setup credentials using environment variables 'AWS_ACCESS_KEY_ID' and 'AWS_SECRET_ACCESS_KEY'
3. Setup profile using `aws configure --profile <name>` and setting env var 'AWS_PROFILE=<name>'

## Create resources for storing terraform state files in S3
This is the first and required step for provisioning a full infrastructure in AWS. We need S3 bucket and Dynamodb table for
simultenious work of several DevOps engineers on this codebase and project.
From the root directory run following commands:

1. Apply state:

        cd terraform-state-s3/
        terraform init
        terraform apply

2. Save local state file in git repository in case it is changed after you run.

        git add terraform.tfstate
        git commit -m 'Updated local state file'
        git push

## AWS common resouces provisioning
Next is a state with common resources configuration in 'terraform-common-infrastructure' directory.
From the root directory run following commands:

1. Apply state:

        cd terraform-common-infrastructure/
        terraform init
        terraform apply

2. Within terraform output you can find endpoints for 3 ERC repositories

## AWS EKS cluster provisioning
1. `terraform plan`
2. `terraform apply`

## kubectl setup
1. Install AWS IAM Authenticator for Kubernetes as described [here](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
2. Install kubectl
3. Use config for kubectl

    * Copy 'eks-kubeconfig' file to ~/.kube/config or set KUBECONFIG env var pointing to it:

            export KUBECONFIG="./eks-kubeconfig"

    * or configure it yourself as descibed [here](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

## ECR login
To login your Docker client in ECR for pushing localy built images run following command:


        $(aws ecr get-login --no-include-email)

## ECR login for local k8s deployments (microk8s, etc)
You may want to use images published in ECR not only in EKS clusters, but on your local machine in minimalistic Kubernetes deployments like MicroK8s or Minikube.
To be able to pull images from ECR registries you need to create Kubernetes secret and pass imagePullSecrets parameter to your pods.
1. Having AWS credentials and K8s config set in your environment run provided Python script:

        ./tools/generate_docker_config_secret.py

2. You'll now have 'ecr-docker-config' secret added:

        kubectl get secrets ecr-docker-config
        NAME                TYPE                             DATA   AGE
        ecr-docker-config   kubernetes.io/dockerconfigjson   1      11s

3. Add 'imagePullSecrets' to your pods:

        imagePullSecrets:$
        - name: "ecr-docker-config"$

Please note that this credentials lasts 12 hours only. Just rerun `./tools/generate_docker_config_secret.py` script and it will update existing secret.

