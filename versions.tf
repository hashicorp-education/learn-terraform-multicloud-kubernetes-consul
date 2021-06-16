terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.1"
    }

    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = "~> 0.5.0"
    }
  }
  required_version = "~> 0.14"
}

