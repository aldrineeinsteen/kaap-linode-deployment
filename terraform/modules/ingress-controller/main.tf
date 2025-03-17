resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "4.12.0"

  create_namespace = true

  set = [
    {
      name  = "controller.service.externalTrafficPolicy"
      value = "Local"
    },
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    }
  ] 
}

resource "null_resource" "fetch_ingress_public_ip" {
  depends_on = [helm_release.nginx_ingress]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for NGINX Ingress LoadBalancer IP..."
      export KUBECONFIG="${var.kube_config_path}"
      while [[ -z "$(kubectl get svc -n ingress-nginx nginx-ingress-ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" ]]; do
        echo "Still waiting for LoadBalancer IP..."
        sleep 10
      done
      INGRESS_IP=$(kubectl get svc -n ingress-nginx nginx-ingress-ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
      echo "$INGRESS_IP" > /tmp/nginx_ingress_ip.txt
    EOT
  }
}

# Read the fetched public IP from the temporary file
data "external" "nginx_ingress_ip" {
  program = ["bash", "-c", "cat /tmp/nginx_ingress_ip.txt | jq -R '{ip: .}'"]

  depends_on = [null_resource.fetch_ingress_public_ip]
}

output "nginx_ingress_public_ip" {
  description = "Public IP of the NGINX Ingress Controller"
  value       = chomp(data.external.nginx_ingress_ip.result["ip"])
}