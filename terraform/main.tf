module "linode_lke_cluster" {
  source = "./modules/lke"
  cluster_name = "kaap-cluster"
  region  = var.region
}


output "kubeconfig" {
  value = <<EOT

# Run the following command to configure kubectl:
export KUBECONFIG="${module.linode_lke_cluster.kube_config_path}"

# To verify your cluster is working, run:
kubectl get nodes

EOT
}

# module "cert_manager" {
#   source = "./modules/cert-manager"
#   kube_config_path = module.linode_lke_cluster.kube_config_path
# }

# module "ingress_controller" {
#   source = "./modules/ingress-controller"
#   kube_config_path = module.linode_lke_cluster.kube_config_path
#   cert_manager_output = module.cert_manager.cert_manager_status
# }

# output "Ingress_Info" {
#   value = <<EOT
# NGINX Ingress Controller Public IP: ${module.ingress_controller.nginx_ingress_public_ip}
# EOT
# }

module "pulsar" {
  source = "./modules/kaap"
  kube_config_path = module.linode_lke_cluster.kube_config_path
}

provider "linode" {
  token = var.linode_token
  
}

provider "kubernetes" {
  config_path = module.linode_lke_cluster.kube_config_path
}