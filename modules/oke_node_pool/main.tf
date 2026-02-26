data "oci_identity_availability_domain" "ad" {
  compartment_id = var.compartment_id
  ad_number      = var.ad_number
}

resource "oci_containerengine_node_pool" "this" {
  cluster_id         = var.oke_cluster_id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.node_pool_name
  node_shape         = var.node_shape

  # Configuração de CPU e Memória
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
      availability_domain = data.oci_identity_availability_domain.ad.name
      subnet_id           = var.node_subnet_id
    }
    size = var.size

    node_pool_pod_network_option_details {
      cni_type       = var.cni_type
      pod_subnet_ids = var.pod_subnet_ids
    }
  }
}