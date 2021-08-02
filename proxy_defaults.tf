## Apply the configuration in main.tf before uncommenting and applying the configuration in this file.
/*
provider "kubernetes-alpha" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec = {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
    env         = {}
  }
}

resource "kubernetes_manifest" "eks_proxy_defaults" {
  provider = kubernetes-alpha.eks
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ProxyDefaults"
    "metadata" = {
      "name"      = "global"
      "namespace" = "default"
    }
    "spec" = {
      "meshGateway" = {
        "mode" = "local"
      }
    }
  }
}

provider "kubernetes-alpha" {
  alias                  = "aks"
  host                   = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_manifest" "aks_proxy_defaults" {
  provider = kubernetes-alpha.aks
  manifest = {
    "apiVersion" = "consul.hashicorp.com/v1alpha1"
    "kind"       = "ProxyDefaults"
    "metadata" = {
      "name"      = "global"
      "namespace" = "default"
    }
    "spec" = {
      "meshGateway" = {
        "mode" = "local"
      }
    }
  }
}
*/
