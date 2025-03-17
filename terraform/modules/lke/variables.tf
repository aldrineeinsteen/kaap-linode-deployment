variable "region" {
    description = "The region where the Linode Kubernetes Engine (LKE) cluster will be deployed."
    type        = string
}

variable "cluster_name" {
    description = "The name of the Linode Kubernetes Engine (LKE) cluster."
    type        = string
}