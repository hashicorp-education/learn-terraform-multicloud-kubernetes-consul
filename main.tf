## EKS Resources

data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../learn-terraform-multicloud-kubernetes-eks/terraform.tfstate"
  }
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
    command     = "aws"
  }
}

resource "helm_release" "consul_dc1" {
  provider   = helm.eks
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"

  values = [
    file("dc1.yaml")
  ]

  provisioner "local-exec" {
    command = "sleep 100 && kubectl config use-context eks && kubectl apply -f proxy_default.yaml"
  }
}

data "kubernetes_secret" "eks_federation_secret" {
  provider = kubernetes.eks
  metadata {
    name = "consul-federation"
  }

  depends_on = [helm_release.consul_dc1]
}

## AKS Resources

data "terraform_remote_state" "aks" {
  backend = "local"
  config = {
    path = "../learn-terraform-multicloud-kubernetes-aks/terraform.tfstate"
  }
}

provider "kubernetes" {
  alias                  = "aks"
  host                   = data.terraform_remote_state.aks.outputs.host
  client_certificate     = base64decode(data.terraform_remote_state.aks.outputs.client_certificate)
  client_key             = base64decode(data.terraform_remote_state.aks.outputs.client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.aks.outputs.cluster_ca_certificate)
}

provider "helm" {
  alias = "aks"
  kubernetes {
    host                   = data.terraform_remote_state.aks.outputs.host
    client_certificate     = base64decode(data.terraform_remote_state.aks.outputs.client_certificate)
    client_key             = base64decode(data.terraform_remote_state.aks.outputs.client_key)
    cluster_ca_certificate = base64decode(data.terraform_remote_state.aks.outputs.cluster_ca_certificate)
  }
}

resource "kubernetes_secret" "aks_federation_secret" {
  provider = kubernetes.aks
  metadata {
    name = "consul-federation"
  }

  data = data.kubernetes_secret.eks_federation_secret.data
}


resource "helm_release" "consul_dc2" {
  provider   = helm.aks
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"

  values = [
    file("dc2.yaml")
  ]

  provisioner "local-exec" {
    command = "sleep 100 && kubectl config use-context aks && kubectl apply -f proxy_default.yaml"
  }

  depends_on = [kubernetes_secret.aks_federation_secret]
}
