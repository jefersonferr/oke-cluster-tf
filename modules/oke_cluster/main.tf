resource "oci_containerengine_cluster" "this" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id
  type               = var.type_of_cluster

  options {
    service_lb_subnet_ids = var.service_lb_subnet_ids

    kubernetes_network_config {
      services_cidr = "10.96.0.0/16"
    }
  }

  cluster_pod_network_options {
      cni_type = var.cni_type
  }

  endpoint_config {
    is_public_ip_enabled = var.is_public_ip_enabled
    subnet_id            = var.endpoint_subnet_id
  }
}