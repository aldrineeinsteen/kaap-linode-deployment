terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

resource "linode_lke_cluster" "hcd_cluster" {
  label   = var.cluster_name
  region  = var.region
  k8s_version = "1.32"
  tags    = ["KaaP", "Linode", "Kubernetes"]

  pool {
    type  = "g6-standard-4"
    autoscaler {
          min = 3
          max = 10
        }
  }
}

resource "local_file" "kube_config_file" {
  # filename = "${path.module}/kubeconfig"
  content  = base64decode(linode_lke_cluster.hcd_cluster.kubeconfig)
  filename = "${path.module}/kubeconfig.yaml"
}

output "kube_config_path" {
  value = abspath(local_file.kube_config_file.filename)
}