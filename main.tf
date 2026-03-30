# =============================================================================
# Local values — derived flags used throughout the configuration
# =============================================================================

locals {
  is_vcn_native  = var.cni_type == "OCI_VCN_IP_NATIVE"
  is_flannel     = var.cni_type == "FLANNEL"
  is_api_public  = var.is_api_endpoint_public
  is_api_private = !var.is_api_endpoint_public
}

# =============================================================================
# VCN
# =============================================================================

module "vcn" {
  source         = "./modules/vcn"
  cidr_block     = var.vcn_cidr_block_16
  dns_label      = "vcnoke"
  compartment_id = var.compartment_id
  display_name   = "vcn-${var.cluster_name}"
}

# =============================================================================
# Gateways — always created (all 4 examples require IG, NAT, and SG)
# =============================================================================

module "ig-vcn" {
  source         = "./modules/internet_gateway"
  compartment_id = var.compartment_id
  display_name   = "ig-${var.cluster_name}"
  vcn_id         = module.vcn.vcn_id
}

module "sg-vcn" {
  source         = "./modules/service_gateway"
  compartment_id = var.compartment_id
  display_name   = "sg-${var.cluster_name}"
  vcn_id         = module.vcn.vcn_id
}

module "ng-vcn" {
  source         = "./modules/network_gateway"
  compartment_id = var.compartment_id
  display_name   = "ng-${var.cluster_name}"
  vcn_id         = module.vcn.vcn_id
}

# =============================================================================
# Route Tables
# =============================================================================

# --- Public route table (Internet Gateway) ---
# Used by: LB subnet (always), API endpoint subnet (when public)
module "rt-public-subnet" {
  source                 = "./modules/default_route_table"
  default_route_table_id = module.vcn.vcn_default_route_table_id
  display_name           = "rt-public-subnet"

  route_rules = [
    {
      network_entity_id = module.ig-vcn.internet_gateway_id
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      description       = "Route to Internet Gateway"
    }
  ]
}

# --- Private route table (NAT + Service Gateway) ---
# Used by: Nodes subnet (always), Pods subnet (VCN-Native),
#          API endpoint subnet (when private)
module "rt-private-subnet" {
  source         = "./modules/route_table"
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "rt-private-subnet"

  route_rules = [
    {
      network_entity_id = module.ng-vcn.nat_gateway_id
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      description       = "Route to NAT Gateway"
    },
    {
      network_entity_id = module.sg-vcn.service_gateway_id
      destination       = module.sg-vcn.all_region_services
      destination_type  = "SERVICE_CIDR_BLOCK"
      description       = "Route to Service Gateway"
    }
  ]
}

# --- Service-only route table (Service Gateway only, no NAT) ---
# Used by: Worker Nodes subnet when CNI is VCN-Native (Examples 3 and 4)
# In the Oracle documentation, VCN-Native worker nodes route only to the
# Service Gateway, while pods handle internet-bound traffic via NAT.
module "rt-service-only" {
  count          = local.is_vcn_native ? 1 : 0
  source         = "./modules/route_table"
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "rt-service-only"

  route_rules = [
    {
      network_entity_id = module.sg-vcn.service_gateway_id
      destination       = module.sg-vcn.all_region_services
      destination_type  = "SERVICE_CIDR_BLOCK"
      description       = "Route to Service Gateway"
    }
  ]
}

# =============================================================================
# Security List — Load Balancer Subnet (always public)
# =============================================================================

module "sl-subnet-lb" {
  source                   = "./modules/default_security_list"
  default_security_list_id = module.vcn.vcn_default_security_list_id
  compartment_id           = var.compartment_id
  display_name             = "sl-subnet-lb"

  ingress_security_rules = [
    {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      source_type = "CIDR_BLOCK"
      tcp_min     = 80
      tcp_max     = 80
      description = "Allow HTTP traffic from internet to load balancers"
    },
    {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      source_type = "CIDR_BLOCK"
      tcp_min     = 443
      tcp_max     = 443
      description = "Allow HTTPS traffic from internet to load balancers"
    }
  ]

  egress_security_rules = [
    {
      protocol         = "6" # TCP
      destination      = var.subnet_nodes_cidr_24
      destination_type = "CIDR_BLOCK"
      tcp_min          = 30000
      tcp_max          = 32767
      description      = "Load balancer to worker nodes node ports"
    },
    {
      protocol         = "6" # TCP
      destination      = var.subnet_nodes_cidr_24
      destination_type = "CIDR_BLOCK"
      tcp_min          = 10256
      tcp_max          = 10256
      description      = "Allow load balancer to communicate with kube-proxy on worker nodes"
    }
  ]
}

# =============================================================================
# Security List — Worker Nodes Subnet
# Differs between Flannel and VCN-Native CNI
# =============================================================================

module "sl-subnet-nodes" {
  source         = "./modules/security_list"
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "sl-subnet-nodes"

  # ---------------------------------------------------------------------------
  # INGRESS RULES
  # ---------------------------------------------------------------------------
  ingress_security_rules = concat(
    # --- Common rules (all scenarios) ---
    [
      {
        protocol    = "6" # TCP
        source      = var.subnet_api_endpoint_cidr
        source_type = "CIDR_BLOCK"
        description = "Allow Kubernetes API endpoint to communicate with worker nodes"
        # Flannel: TCP/ALL, VCN-Native: TCP/10250
        tcp_min = local.is_flannel ? 1 : 10250
        tcp_max = local.is_flannel ? 65535 : 10250
      },
      {
        protocol    = "1" # ICMP
        source      = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        icmp_type   = 3
        icmp_code   = 4
        description = "Path Discovery"
      },
      {
        protocol    = "6" # TCP
        source      = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        tcp_min     = 22
        tcp_max     = 22
        description = "Allow inbound SSH traffic to worker nodes"
      },
      {
        protocol    = "6" # TCP
        source      = var.subnet_lb_cidr_24
        source_type = "CIDR_BLOCK"
        tcp_min     = 30000
        tcp_max     = 32767
        description = "Load balancer to worker nodes node ports"
      },
      {
        protocol    = "6" # TCP
        source      = var.subnet_lb_cidr_24
        source_type = "CIDR_BLOCK"
        tcp_min     = 10256
        tcp_max     = 10256
        description = "Allow load balancer to communicate with kube-proxy on worker nodes"
      }
    ],

    # --- Flannel-only: pod-to-pod via overlay on worker nodes subnet ---
    local.is_flannel ? [
      {
        protocol    = "all"
        source      = var.subnet_nodes_cidr_24
        source_type = "CIDR_BLOCK"
        description = "Allow pods on one worker node to communicate with pods on other worker nodes"
      }
    ] : [],

    # --- VCN-Native-only: worker nodes receive traffic from pods subnet ---
    local.is_vcn_native ? [
      {
        protocol    = "all"
        source      = var.subnet_pods_cidr_19
        source_type = "CIDR_BLOCK"
        description = "Allow pods to communicate with worker nodes"
      }
    ] : []
  )

  # ---------------------------------------------------------------------------
  # EGRESS RULES
  # ---------------------------------------------------------------------------
  egress_security_rules = concat(
    # --- Common rules (all scenarios) ---
    [
      {
        protocol         = "1" # ICMP
        destination      = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        icmp_type        = 3
        icmp_code        = 4
        description      = "Path Discovery"
      },
      {
        protocol         = "6" # TCP
        destination      = module.sg-vcn.all_region_services
        destination_type = "SERVICE_CIDR_BLOCK"
        description      = "Allow worker nodes to communicate with OKE"
      },
      {
        protocol         = "6" # TCP
        destination      = var.subnet_api_endpoint_cidr
        destination_type = "CIDR_BLOCK"
        tcp_min          = 6443
        tcp_max          = 6443
        description      = "Kubernetes worker to Kubernetes API endpoint communication"
      },
      {
        protocol         = "6" # TCP
        destination      = var.subnet_api_endpoint_cidr
        destination_type = "CIDR_BLOCK"
        tcp_min          = 12250
        tcp_max          = 12250
        description      = "Kubernetes worker to control plane communication"
      }
    ],

    # --- Flannel-only: pod-to-pod and internet access from workers ---
    local.is_flannel ? [
      {
        protocol         = "all"
        destination      = var.subnet_nodes_cidr_24
        destination_type = "CIDR_BLOCK"
        description      = "Allow pods on one worker node to communicate with pods on other worker nodes"
      },
      {
        protocol         = "all"
        destination      = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        description      = "Worker Nodes access to Internet"
      }
    ] : [],

    # --- VCN-Native-only: worker nodes to pods subnet ---
    local.is_vcn_native ? [
      {
        protocol         = "all"
        destination      = var.subnet_pods_cidr_19
        destination_type = "CIDR_BLOCK"
        description      = "Allow worker nodes to access pods"
      },
      {
        protocol         = "all"
        destination      = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        description      = "Worker Nodes access to Internet"
      }
    ] : []
  )
}

# =============================================================================
# Security List — API Endpoint Subnet
# Differs based on CNI (pods rules) and API exposure (ingress source)
# =============================================================================

module "sl-subnet-api-endpoint" {
  source         = "./modules/security_list"
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "sl-subnet-api-endpoint"

  # ---------------------------------------------------------------------------
  # INGRESS RULES
  # ---------------------------------------------------------------------------
  ingress_security_rules = concat(
    # --- Common rules (all scenarios) ---
    [
      {
        protocol    = "6" # TCP
        source      = var.subnet_nodes_cidr_24
        source_type = "CIDR_BLOCK"
        tcp_min     = 6443
        tcp_max     = 6443
        description = "Kubernetes worker to Kubernetes API endpoint communication"
      },
      {
        protocol    = "6" # TCP
        source      = var.subnet_nodes_cidr_24
        source_type = "CIDR_BLOCK"
        tcp_min     = 12250
        tcp_max     = 12250
        description = "Kubernetes worker to control plane communication"
      },
      {
        protocol    = "1" # ICMP
        source      = var.subnet_nodes_cidr_24
        source_type = "CIDR_BLOCK"
        icmp_type   = 3
        icmp_code   = 4
        description = "Path Discovery"
      }
    ],

    # --- Public API: allow external access from internet ---
    local.is_api_public ? [
      {
        protocol    = "6" # TCP
        source      = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        tcp_min     = 6443
        tcp_max     = 6443
        description = "External access to Kubernetes API endpoint"
      }
    ] : [],

    # --- VCN-Native-only: pods to API endpoint ---
    local.is_vcn_native ? [
      {
        protocol    = "6" # TCP
        source      = var.subnet_pods_cidr_19
        source_type = "CIDR_BLOCK"
        tcp_min     = 6443
        tcp_max     = 6443
        description = "Pod to Kubernetes API endpoint communication"
      },
      {
        protocol    = "6" # TCP
        source      = var.subnet_pods_cidr_19
        source_type = "CIDR_BLOCK"
        tcp_min     = 12250
        tcp_max     = 12250
        description = "Pod to Kubernetes API endpoint communication"
      }
    ] : []
  )

  # ---------------------------------------------------------------------------
  # EGRESS RULES
  # ---------------------------------------------------------------------------
  egress_security_rules = concat(
    # --- Common rules (all scenarios) ---
    [
      {
        protocol         = "6" # TCP
        destination      = module.sg-vcn.all_region_services
        destination_type = "SERVICE_CIDR_BLOCK"
        description      = "Allow Kubernetes API endpoint to communicate with OKE"
      },
      {
        protocol         = "1" # ICMP
        destination      = module.sg-vcn.all_region_services
        destination_type = "SERVICE_CIDR_BLOCK"
        icmp_type        = 3
        icmp_code        = 4
        description      = "Path Discovery"
      },
      {
        protocol         = "1" # ICMP
        destination      = var.subnet_nodes_cidr_24
        destination_type = "CIDR_BLOCK"
        icmp_type        = 3
        icmp_code        = 4
        description      = "Path Discovery"
      }
    ],

    # --- Flannel: API endpoint to worker nodes TCP/ALL ---
    local.is_flannel ? [
      {
        protocol         = "6" # TCP
        destination      = var.subnet_nodes_cidr_24
        destination_type = "CIDR_BLOCK"
        description      = "Allow Kubernetes API endpoint to communicate with worker nodes"
      }
    ] : [],

    # --- VCN-Native: API endpoint to worker nodes TCP/10250 and to pods ---
    local.is_vcn_native ? [
      {
        protocol         = "6" # TCP
        destination      = var.subnet_nodes_cidr_24
        destination_type = "CIDR_BLOCK"
        tcp_min          = 10250
        tcp_max          = 10250
        description      = "Allow Kubernetes API endpoint to communicate with worker nodes"
      },
      {
        protocol         = "all"
        destination      = var.subnet_pods_cidr_19
        destination_type = "CIDR_BLOCK"
        description      = "Allow Kubernetes API endpoint to communicate with pods"
      }
    ] : []
  )
}

# =============================================================================
# Security List — Pods Subnet (VCN-Native CNI only — Examples 3 and 4)
# =============================================================================

module "sl-subnet-pods" {
  count          = local.is_vcn_native ? 1 : 0
  source         = "./modules/security_list"
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "sl-subnet-pods"

  ingress_security_rules = [
    {
      protocol    = "all"
      source      = var.subnet_nodes_cidr_24
      source_type = "CIDR_BLOCK"
      description = "Allow worker nodes to access pods"
    },
    {
      protocol    = "all"
      source      = var.subnet_api_endpoint_cidr
      source_type = "CIDR_BLOCK"
      description = "Allow Kubernetes API endpoint to communicate with pods"
    },
    {
      protocol    = "all"
      source      = var.subnet_pods_cidr_19
      source_type = "CIDR_BLOCK"
      description = "Allow pods to communicate with other pods"
    }
  ]

  egress_security_rules = [
    {
      protocol         = "all"
      destination      = var.subnet_pods_cidr_19
      destination_type = "CIDR_BLOCK"
      description      = "Allow pods to communicate with other pods"
    },
    {
      protocol         = "6" # TCP
      destination      = module.sg-vcn.all_region_services
      destination_type = "SERVICE_CIDR_BLOCK"
      description      = "Allow pods to communicate with OCI services"
    },
    {
      protocol         = "1" # ICMP
      destination      = module.sg-vcn.all_region_services
      destination_type = "SERVICE_CIDR_BLOCK"
      icmp_type        = 3
      icmp_code        = 4
      description      = "Path Discovery"
    },
    {
      protocol         = "all"
      destination      = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      description      = "Allow pods to communicate with internet"
    },
    {
      protocol         = "6" # TCP
      destination      = var.subnet_api_endpoint_cidr
      destination_type = "CIDR_BLOCK"
      tcp_min          = 6443
      tcp_max          = 6443
      description      = "Pods to Kubernetes API endpoint communication"
    },
    {
      protocol         = "6" # TCP
      destination      = var.subnet_api_endpoint_cidr
      destination_type = "CIDR_BLOCK"
      tcp_min          = 12250
      tcp_max          = 12250
      description      = "Pods to Kubernetes API endpoint communication"
    },
    {
      protocol         = "6" # TCP
      destination      = var.subnet_nodes_cidr_24
      destination_type = "CIDR_BLOCK"
      description      = "Allow pods to communicate with worker nodes"
    }
  ]
}

# =============================================================================
# Subnets
# =============================================================================

# --- Load Balancer Subnet (always public) ---
module "subnet-lb" {
  source            = "./modules/subnet"
  cidr_block        = var.subnet_lb_cidr_24
  compartment_id    = var.compartment_id
  display_name      = "subnet-lb"
  dns_label         = "subnetlb"
  route_table_id    = module.rt-public-subnet.default_route_table_id
  security_list_ids = [module.sl-subnet-lb.default_security_list_id]
  vcn_id            = module.vcn.vcn_id
}

# --- API Endpoint Subnet ---
# Public (IG route) for Examples 1,3 | Private (NAT+SG route) for Examples 2,4
module "subnet-api-endpoint" {
  source            = "./modules/subnet"
  cidr_block        = var.subnet_api_endpoint_cidr
  compartment_id    = var.compartment_id
  display_name      = "subnet-api-endpoint"
  dns_label         = "subnetapi"
  private_subnet    = local.is_api_private
  route_table_id    = local.is_api_public ? module.rt-public-subnet.default_route_table_id : module.rt-private-subnet.route_table_id
  security_list_ids = [module.sl-subnet-api-endpoint.security_list_id]
  vcn_id            = module.vcn.vcn_id
}

# --- Worker Nodes Subnet (always private) ---
# Flannel (Ex 1,2): route via NAT + SG (rt-private-subnet)
# VCN-Native (Ex 3,4): route via SG only (rt-service-only)
module "subnet-nodes" {
  source            = "./modules/subnet"
  cidr_block        = var.subnet_nodes_cidr_24
  compartment_id    = var.compartment_id
  display_name      = "subnet-nodes"
  dns_label         = "subnetnodes"
  private_subnet    = true
  route_table_id    = local.is_flannel ? module.rt-private-subnet.route_table_id : module.rt-service-only[0].route_table_id
  security_list_ids = [module.sl-subnet-nodes.security_list_id]
  vcn_id            = module.vcn.vcn_id
}

# --- Pods Subnet (VCN-Native CNI only — Examples 3 and 4) ---
module "subnet-pods" {
  count             = local.is_vcn_native ? 1 : 0
  source            = "./modules/subnet"
  cidr_block        = var.subnet_pods_cidr_19
  compartment_id    = var.compartment_id
  display_name      = "subnet-pods"
  dns_label         = "subnetpods"
  private_subnet    = true
  route_table_id    = module.rt-private-subnet.route_table_id
  security_list_ids = [module.sl-subnet-pods[0].security_list_id]
  vcn_id            = module.vcn.vcn_id
}

# =============================================================================
# OKE Cluster
# =============================================================================

module "oke-cluster" {
  source                = "./modules/oke_cluster"
  compartment_id        = var.compartment_id
  cluster_name          = var.cluster_name
  vcn_id                = module.vcn.vcn_id
  type_of_cluster       = var.type_of_cluster
  cni_type              = var.cni_type
  kubernetes_version    = var.kubernetes_version
  is_public_ip_enabled  = var.is_api_endpoint_public
  service_lb_subnet_ids = [module.subnet-lb.subnet_id]
  endpoint_subnet_id    = module.subnet-api-endpoint.subnet_id
}

# =============================================================================
# OKE Node Pool
# =============================================================================

module "oke-node-pool" {
  source             = "./modules/oke_node_pool"
  oke_cluster_id     = module.oke-cluster.cluster_id
  compartment_id     = var.compartment_id
  ad_name            = var.ad_name
  node_pool_name     = "${var.cluster_name}-node-pool"
  kubernetes_version = var.kubernetes_version
  node_shape         = var.pool_node_shape
  # Uses the effective image: user-provided OCID or auto-resolved from data source
  node_image_id      = local.effective_node_image_id
  ocpus              = var.ocpus
  memory_in_gbs      = var.memory_in_gbs
  node_subnet_id     = module.subnet-nodes.subnet_id
  size               = var.pool_size
  cni_type           = var.cni_type
  pod_subnet_ids     = local.is_vcn_native ? [module.subnet-pods[0].subnet_id] : []
}
