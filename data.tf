# =============================================================================
# Data Sources — Dynamic image resolution for OKE Node Pools
# =============================================================================
#
# This data source queries the OKE API for available node pool images that are
# compatible with the selected Kubernetes version. It is used as a fallback
# when no explicit pool_node_image_id is provided.
#
# The oci_containerengine_node_pool_option data source returns all available
# images (sources) for the given k8s version, filtered by the region
# configured in the OCI provider. This means the image OCIDs returned are
# already region-specific — no additional region filtering is needed.
# =============================================================================

data "oci_containerengine_node_pool_option" "node_pool_images" {
  #  "all" retrieves options across all clusters in the compartment
  node_pool_option_id = "all"

  # Required: scopes the query to the target compartment
  compartment_id = var.compartment_id

  # Filter by the selected Kubernetes version so only compatible images appear
  node_pool_k8s_version = var.kubernetes_version
}

# =============================================================================
# Locals — Select the best OKE image from the data source results
# =============================================================================

locals {
  # -------------------------------------------------------------------------
  # Filter: keep only Oracle Linux 8.x OKE worker node images (aarch64 excluded)
  # The source_name follows the pattern:
  #   "OKE Worker Node Oracle Linux 8.x - <k8s_version>"
  # -------------------------------------------------------------------------
  oke_ol8_images = [
    for src in data.oci_containerengine_node_pool_option.node_pool_images.sources :
    src if(
    src.source_type == "IMAGE" &&
    can(regex("Oracle Linux 8", src.source_name)) &&
    can(regex("OKE", src.source_name)) &&
    !can(regex("aarch64", src.source_name))
    )
  ]

  # Pick the first matching image (latest) as the auto-resolved default
  auto_resolved_image_id = length(local.oke_ol8_images) > 0 ? local.oke_ol8_images[0].image_id : ""

  # Final image ID: use the user-provided OCID if set, otherwise auto-resolve
  effective_node_image_id = (
    var.pool_node_image_id != null && var.pool_node_image_id != ""
    ? var.pool_node_image_id
    : local.auto_resolved_image_id
  )
}