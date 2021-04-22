# provider "kubernetes-alpha" {
#   alias = "eks"
#   host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
#   cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority)
#   exec = {
#     api_version = "client.authentication.k8s.io/v1alpha1"
#     args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
#     command     = "aws"
#     env         = {}
#   }
# }
#
# resource "kubernetes_manifest" "eks_proxy_defaults" {
#   provider = kubernetes-alpha.eks
#   manifest = {
#     "apiVersion" = "consul.hashicorp.com/v1alpha1"
#     "kind"       = "ProxyDefaults"
#     "metadata" = {
#       "name"      = "global"
#       "namespace" = "default"
#     }
#     "spec" = {
#       "meshGateway" = {
#         "mode" = "remote"
#       }
#     }
#   }
#   depends_on = [helm_release.consul_dc1]
# }
#
# provider "kubernetes-alpha" {
#   alias = "aks"
# host                   = data.terraform_remote_state.aks.outputs.host
# client_certificate     = base64decode(data.terraform_remote_state.aks.outputs.client_certificate)
# client_key             = base64decode(data.terraform_remote_state.aks.outputs.client_key)
# cluster_ca_certificate = base64decode(data.terraform_remote_state.aks.outputs.cluster_ca_certificate)
# }
#
# resource "kubernetes_manifest" "aks_proxy_defaults" {
#   provider = kubernetes-alpha.aks
#   manifest = {
#     "apiVersion" = "consul.hashicorp.com/v1alpha1"
#     "kind"       = "ProxyDefaults"
#     "metadata" = {
#       "name"      = "global"
#       "namespace" = "default"
#     }
#     "spec" = {
#       "meshGateway" = {
#         "mode" = "remote"
#       }
#     }
#   }
#   depends_on = [helm_release.consul_dc2]
# }
