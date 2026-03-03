module "vcn" {
    source          = "./modules/vcn"
    cidr_block      = var.vcn_cidr_block_16 #"10.6.0.0/16"
    dns_label       = "vcnoke"
    compartment_id  = var.compartment_id
    display_name    = "vcn-${var.cluster_name}"
}

module "ig-vcn" {
    source          = "./modules/internet_gateway"
    compartment_id  = var.compartment_id
    display_name    = "ig-${var.cluster_name}"
    vcn_id          = module.vcn.vcn_id
}

module "sg-vcn" {
    source          = "./modules/service_gateway"
    compartment_id  = var.compartment_id
    display_name    = "sg-${var.cluster_name}"
    vcn_id          = module.vcn.vcn_id
    service_id      = var.service_id
}

module "ng-vcn" {
    source          = "./modules/network_gateway"
    compartment_id  = var.compartment_id
    display_name    = "ng-${var.cluster_name}"
    vcn_id          = module.vcn.vcn_id
}

module "sl-subnet-lb" {
    source                    = "./modules/default_security_list"
    default_security_list_id  = module.vcn.vnc_default_security_list_id
    compartment_id            = var.compartment_id
    display_name              = "sl-subnet-lb"

  ingress_security_rules = [
    {
      protocol     = "6" # TCP
      source       = "0.0.0.0/0"
      source_type  = "CIDR_BLOCK"
      tcp_min      = 80
      tcp_max      = 80
    },
    {
      protocol     = "6" # TCP
      source       = "0.0.0.0/0"
      source_type  = "CIDR_BLOCK"
      tcp_min      = 443
      tcp_max      = 443
    }
  ]

  egress_security_rules = [
    {
      protocol         = "6" # TCP
      destination      = var.subnet_nodes_cidr_24
      destination_type = "CIDR_BLOCK"
      tcp_min          = 30000
      tcp_max          = 32767
    },
    {
      protocol         = "6" # TCP
      destination      = var.subnet_nodes_cidr_24
      destination_type = "CIDR_BLOCK"
      tcp_min          = 10256
      tcp_max          = 10256
    }
  ]
}

module "sl-subnet-nodes" {
  source         = "./modules/security_list"
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "sl-subnet-nodes"

  ingress_security_rules = [
    {
      protocol     = "6" # TCP
      source       = var.subnet_api_endpoint_cidr_29
      source_type  = "CIDR_BLOCK"
      tcp_min      = 10250
      tcp_max      = 10250
      description  = "Allow Kubernetes API endpoint to communicate with worker nodes"
    },
    {
      protocol     = "1" # ICMP
      source       = "0.0.0.0/0"
      source_type  = "CIDR_BLOCK"
      icmp_type    = 3
      icmp_code    = 4
      description  = "Path Discovery"
    },
    {
      protocol     = "6" # TCP
      source       = "0.0.0.0/0"
      source_type  = "CIDR_BLOCK"
      tcp_min      = 22
      tcp_max      = 22
      description  = "Allow inbound SSH traffic to worker nodes"
    },
    {
      protocol     = "6" # TCP
      source       = var.subnet_lb_cidr_24
      source_type  = "CIDR_BLOCK"
      tcp_min      = 30000
      tcp_max      = 32767
      description  = "Load balancer to worker nodes node ports"
    },
    {
      protocol     = "6" # TCP
      source       = var.subnet_lb_cidr_24
      source_type  = "CIDR_BLOCK"
      tcp_min      = 10256
      tcp_max      = 10256
      description  = "Allow load balancer to communicate with kube-proxy on worker nodes"
    }
  ]

  egress_security_rules = [
    {
      protocol         = "all"
      destination      = var.subnet_pods_cidr_19
      destination_type = "CIDR_BLOCK"
      description      = "Allow worker nodes to access pods"
    },
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
      destination      = var.all_region_services
      destination_type = "SERVICE_CIDR_BLOCK"
      description      = "Allow worker nodes to communicate with OKE"
    },
    {
      protocol         = "6" # TCP
      destination      = var.subnet_api_endpoint_cidr_29
      destination_type = "CIDR_BLOCK"
      tcp_min          = 12250
      tcp_max          = 12250
      description      = "Kubernetes worker to Kubernetes API endpoint communication"
    },
    {
      protocol         = "6" # TCP
      destination      = var.subnet_api_endpoint_cidr_29
      destination_type = "CIDR_BLOCK"
      tcp_min          = 6443
      tcp_max          = 6443
      description      = "Kubernetes worker to Kubernetes API endpoint communication"
    }
  ]
}

module "sl-subnet-api-endpoint" {
  source         = "./modules/security_list"
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "sl-subnet-api-endpoint"

  ingress_security_rules = [
    {
      protocol     = "6" # TCP
      source       = "0.0.0.0/0"
      source_type  = "CIDR_BLOCK"
      tcp_min      = 6443
      tcp_max      = 6443
      description  = "External access to Kubernetes API endpoint"
    },
    {
      protocol     = "6" # TCP
      source       = var.subnet_nodes_cidr_24
      source_type  = "CIDR_BLOCK"
      tcp_min      = 6443
      tcp_max      = 6443
      description  = "Kubernetes nodes to Kubernetes API endpoint communication"
    },
    {
      protocol     = "6" # TCP
      source       = var.subnet_nodes_cidr_24
      source_type  = "CIDR_BLOCK"
      tcp_min      = 12250
      tcp_max      = 12250
      description  = "Kubernetes nodes to control plane communication"
    },
    {
      protocol     = "1" # ICMP
      source       = var.subnet_nodes_cidr_24
      source_type  = "CIDR_BLOCK"
      icmp_type    = 3
      icmp_code    = 4
      description  = "Path Discovery"
    },
    {
      protocol     = "6" # TCP
      source       = var.subnet_pods_cidr_19
      source_type  = "CIDR_BLOCK"
      tcp_min      = 6443
      tcp_max      = 6443
      description  = "Pod to Kubernetes API endpoint communication"
    },
    {
      protocol     = "6" # TCP
      source       = var.subnet_pods_cidr_19
      source_type  = "CIDR_BLOCK"
      tcp_min      = 12250
      tcp_max      = 12250
      description  = "Pod to Kubernetes API endpoint communication"
    }
  ]

  egress_security_rules = [
    {
      protocol         = "6" # TCP
      destination      = var.all_region_services
      destination_type = "SERVICE_CIDR_BLOCK"
      description      = "Allow Kubernetes API endpoint to communicate with OKE"
    },
    {
      protocol         = "1" # ICMP
      destination      = var.all_region_services
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
    },
    {
      protocol         = "all"
      destination      = var.subnet_pods_cidr_19
      destination_type = "CIDR_BLOCK"
      description      = "Allow Kubernetes API endpoint to communicate with pods"
    },
    {
      protocol         = "6" # TCP
      destination      = var.subnet_nodes_cidr_24
      destination_type = "CIDR_BLOCK"
      tcp_min          = 10250
      tcp_max          = 10250
      description      = "Allow Kubernetes API endpoint to communicate with worker nodes"
    }
  ]
}

module "sl-subnet-pods" {
  source         = "./modules/security_list"
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "sl-subnet-pods"

  ingress_security_rules = [
    {
      protocol     = "all"
      source       = var.subnet_nodes_cidr_24
      source_type  = "CIDR_BLOCK"
      description  = "Allow worker nodes to access pods"
    },
    {
      protocol     = "all"
      source       = var.subnet_api_endpoint_cidr_29
      source_type  = "CIDR_BLOCK"
      description  = "Allow Kubernetes API endpoint to communicate with pods"
    },
    {
      protocol     = "all"
      source       = var.subnet_pods_cidr_19
      source_type  = "CIDR_BLOCK"
      description  = "Allow pods to communicate with other pods"
    }
  ]

  egress_security_rules = [
    {
      protocol         = "all"
      destination      = var.subnet_pods_cidr_19
      destination_type = "CIDR_BLOCK"
      description      = "Allow pods to communicate with other pods"
    }
    {
      protocol         = "6" # TCP
      destination      = var.all_region_services
      destination_type = "SERVICE_CIDR_BLOCK"
      description      = "Allow pods to communicate with OCI services"
    },
    {
      protocol         = "1" # ICMP
      destination      = var.all_region_services
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
      destination      = var.subnet_api_endpoint_cidr_29
      destination_type = "CIDR_BLOCK"
      tcp_min          = 12250
      tcp_max          = 12250
      description      = "Pods to Kubernetes API endpoint communication"
    },
    {
      protocol         = "6" # TCP
      destination      = var.subnet_api_endpoint_cidr_29
      destination_type = "CIDR_BLOCK"
      tcp_min          = 6443
      tcp_max          = 6443
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

module "subnet-lb" {
    source = "./modules/subnet"
    cidr_block                 = var.subnet_lb_cidr_24 #"10.6.0.0/24"
    compartment_id             = var.compartment_id
    display_name               = "subnet-lb"
    dns_label                  = "subnetlb"
    route_table_id             = module.rt-public-subnet.default_route_table_id
    security_list_ids          = [module.sl-subnet-lb.default_security_list_id]
    vcn_id                     = module.vcn.vcn_id
}

module "subnet-api-endpoint" {
    source = "./modules/subnet"
    cidr_block                 = var.subnet_api_endpoint_cidr_29 #"10.6.3.0/29"
    compartment_id             = var.compartment_id
    display_name               = "subnet-api-endpoint"
    dns_label                  = "subnetapi"
    route_table_id             = module.rt-public-subnet.default_route_table_id
    security_list_ids          = [module.sl-subnet-api-endpoint.security_list_id]
    vcn_id                     = module.vcn.vcn_id
}

module "subnet-nodes" {
    source = "./modules/subnet"
    cidr_block                 = var.subnet_nodes_cidr_24 #"10.6.1.0/24"
    compartment_id             = var.compartment_id
    display_name               = "subnet-nodes"
    dns_label                  = "subnetnodes"
    private_subnet             = "true"
    route_table_id             = module.rt-private-subnet.route_table_id
    security_list_ids          = [module.sl-subnet-nodes.security_list_id]
    vcn_id                     = module.vcn.vcn_id
}

module "subnet-pods" {
    source = "./modules/subnet"
    cidr_block                 = var.subnet_pods_cidr_19 #"10.6.32.0/19"
    compartment_id             = var.compartment_id
    display_name               = "subnet-pods"
    dns_label                  = "subnetpods"
    private_subnet             = "true"
    route_table_id             = module.rt-private-subnet.route_table_id
    security_list_ids          = [module.sl-subnet-pods.security_list_id]
    vcn_id                     = module.vcn.vcn_id
}

module "rt-public-subnet" {
  source                = "./modules/default_route_table"
  default_route_table_id = module.vcn.vnc_default_route_table_id
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
      destination       = var.all_region_services
      destination_type  = "SERVICE_CIDR_BLOCK"
      description       = "Route to Service Gateway"
    }
  ]
}

module "oke-cluster" {
  source                = "./modules/oke_cluster"
  compartment_id        = var.compartment_id
  cluster_name          = var.cluster_name
  vcn_id                = module.vcn.vcn_id
  type_of_cluster       = var.type_of_cluster # 'BASIC_CLUSTER' or 'ENHANCED_CLUSTER'
  cni_type              = var.cni_type        # 'FLANNEL' or 'OCI_VCN_IP_NATIVE'
  service_lb_subnet_ids = [module.subnet-lb.subnet_id]
  endpoint_subnet_id    = module.subnet-api-endpoint.subnet_id
}

module "oke-node-pool" {
  source                  = "./modules/oke_node_pool"
  oke_cluster_id          = module.oke-cluster.cluster_id
  compartment_id          = var.compartment_id
  node_pool_name          = "${var.cluster_name}-node-pool"
  node_shape              = var.pool_node_shape # Eg. 'VM.Standard.E6.Flex'
  node_image_id           = var.pool_node_image_id # Search in: https://docs.oracle.com/en-us/iaas/images/oke-worker-node-oracle-linux-8x/oracle-linux-8.10-gen2-gpu-2025.11.20-0-oke-1.34.2-1345.htm
  ocpus                   = var.ocpus
  memory_in_gbs           = var.memory_in_gbs
  node_subnet_id          = module.subnet-nodes.subnet_id
  size                    = var.pool_size
  pod_subnet_ids          = [module.subnet-pods.subnet_id]
}
