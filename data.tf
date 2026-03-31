# =============================================================================
# Data Sources — Dynamic image resolution for OKE Node Pools
# =============================================================================
#
# Queries the OKE API for available node pool images compatible with the
# selected Kubernetes version. Used as fallback when pool_node_image_id
# is not provided.
#
# Image source_name format:
#   "Oracle-Linux-8.10-2025.02.28-0-OKE-1.31.1-816"
#
# The data source returns images scoped to the region configured in the
# OCI provider — no additional region filtering is needed.
# =============================================================================

data "oci_containerengine_node_pool_option" "node_pool_images" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_id
}

# =============================================================================
# Locals — Select the best OKE Oracle Linux 8 image
# =============================================================================

locals {
  # Strip the "v" prefix from kubernetes_version for matching against
  # source_name (e.g., "v1.31.1" -> "1.31.1")
  k8s_version_stripped = replace(var.kubernetes_version, "/^v/", "")

  # ---------------------------------------------------------------------------
  # Filter: OKE Oracle Linux 8 images matching the Kubernetes version
  #
  # Criteria:
  #   1. source_type is IMAGE
  #   2. source_name contains "Oracle-Linux-8" (Oracle Linux 8.x)
  #   3. source_name contains "OKE-<k8s_version>" (e.g., "OKE-1.31.1")
  #   4. Excludes aarch64 (ARM) and Gen2-GPU images
  # ---------------------------------------------------------------------------
  oke_ol8_images = [
    for src in data.oci_containerengine_node_pool_option.node_pool_images.sources :
    src if alltrue([
      src.source_type == "IMAGE",
      length(regexall("Oracle-Linux-8", src.source_name)) > 0,
      length(regexall("OKE-${local.k8s_version_stripped}", src.source_name)) > 0,
      length(regexall("aarch64", src.source_name)) == 0,
      length(regexall("Gen2-GPU", src.source_name)) == 0,
    ])
  ]

  # Pick the first matching image (latest build) as auto-resolved default
  auto_resolved_image_id = length(local.oke_ol8_images) > 0 ? local.oke_ol8_images[0].image_id : null

  # Final image ID: user-provided takes precedence, otherwise auto-resolve
  effective_node_image_id = coalesce(
    var.pool_node_image_id != "" ? var.pool_node_image_id : null,
    local.auto_resolved_image_id
  )
}

# =============================================================================
# Validation — fail early if no image could be resolved
# =============================================================================

resource "terraform_data" "validate_node_image" {
  lifecycle {
    precondition {
      condition     = local.effective_node_image_id != null
      error_message = <<-EOT
        Could not resolve an OKE worker node image.
        No Oracle Linux 8 image was found for Kubernetes version "${var.kubernetes_version}"
        in the current region.

        Either:
          1. Set pool_node_image_id explicitly with a valid image OCID.
          2. Verify that the Kubernetes version is available in your region.

        Find image OCIDs at:
        https://docs.oracle.com/en-us/iaas/images/oke-worker-node-oracle-linux-8x/
      EOT
    }
  }
}