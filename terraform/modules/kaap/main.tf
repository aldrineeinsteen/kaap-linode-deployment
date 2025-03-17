resource "helm_release" "pulsar" {
  name             = "pulsar"
  repository       = "https://datastax.github.io/kaap"
  chart            = "kaap-stack"
  namespace        = "pulsar"
  create_namespace = true

  values = [
    # file("${path.module}/values.yaml")
    file("${path.module}/values-self-signed.yaml")
  ]
}
provider "helm" { 
  kubernetes = {
    config_path = var.kube_config_path
  }
}