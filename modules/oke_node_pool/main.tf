resource "oci_containerengine_node_pool" "this" {
  cluster_id         = var.oke_cluster_id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.node_pool_name
  node_shape         = var.node_shape

  # CPU and Memory configuration
  node_shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = var.node_image_id
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  node_config_details {
    placement_configs {
      availability_domain = var.ad_name
      subnet_id           = var.node_subnet_id
    }
    size = var.size

    node_pool_pod_network_option_details {
      cni_type       = var.cni_type == "FLANNEL" ? "FLANNEL_OVERLAY" : var.cni_type
      pod_subnet_ids = var.cni_type == "OCI_VCN_IP_NATIVE" ? var.pod_subnet_ids : []
    }
  }
}