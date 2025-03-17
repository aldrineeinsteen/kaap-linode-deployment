terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 2.34.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
  }
}