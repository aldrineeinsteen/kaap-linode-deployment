resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.17.1"

  create_namespace = true

  set = [{
    name  = "installCRDs"
    value = "true"
  }]
}

provider "helm" {
  kubernetes = {
    config_path = var.kube_config_path
  }
}

output "cert_manager_status" {
  description = "Cert-Manager installation status"
  value       = "Cert-Manager installed successfully"
}