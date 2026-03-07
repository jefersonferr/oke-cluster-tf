# OCI OKE Infrastructure as Code – Reference Implementation

## Overview

This repository provides a Terraform-based reference implementation to provision a complete Kubernetes environment on **Oracle Cloud Infrastructure (OCI)** using **Oracle Kubernetes Engine (OKE)**.

The implementation follows the official networking guidance from:

**Oracle Documentation – Example 3:**
*Cluster with OCI CNI Plugin, Public Kubernetes API Endpoint, Private Worker Nodes, and Public Load Balancers*

Official reference:
https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-oci-cni-publick8sapi_privateworkers_publiclb

Platform references:

* Oracle Cloud Infrastructure
* Oracle Kubernetes Engine

---

# Architecture Summary

This repository provisions a production-ready OKE cluster with:

* Public Kubernetes API Endpoint
* Private Worker Nodes
* Public Load Balancers
* OCI VCN-Native CNI Plugin (`OCI_VCN_IP_NATIVE`)
* Dedicated Pod Subnet
* Service Gateway access to OCI services
* NAT Gateway for private outbound traffic

This architecture ensures:

* Secure segmentation between control plane, nodes, and pods
* Explicit ingress and egress control
* Internet exposure only where required

---

# Infrastructure Components

## Networking

* VCN (`/16`)
* Internet Gateway
* NAT Gateway
* Service Gateway
* Public Route Table
* Private Route Table
* Dedicated Security Lists per subnet
* Four Subnets:

  * Load Balancer (`/24`)
  * API Endpoint (`/29`)
  * Worker Nodes (`/24`)
  * Pods (`/19`)

---

# OKE Configuration

## Cluster

* Type: `BASIC_CLUSTER` or `ENHANCED_CLUSTER`
* CNI: `OCI_VCN_IP_NATIVE`
* Public Kubernetes API endpoint
* Dedicated endpoint subnet
* Service LB subnet configured

## Node Pool

* Configurable shape
* Flexible OCPU and memory sizing
* Worker nodes deployed in private subnet
* Pod subnet attached
* Configurable node count

---

# OKE Cluster Deployment with OCI Resource Manager and Terraform
[Deploy this repository](oci-deployment.md)

---

# Terraform Input Variables

Below are the required and configurable variables supported by this repository.

---

## Core Configuration

```hcl
variable "region" {
  type        = string
  description = "The OCI region where resources will be created (e.g., sa-saopaulo-1)"
}

variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where resource will be created"
}

variable "cluster_name" {
  type        = string
  description = "The display name of the OKE cluster"
}
```

---

## Network Configuration

```hcl
variable "vcn_cidr_block_16" {
  type        = string
  description = "IPv4 CIDR /16 block for the VCN, providing 65,536 addresses (e.g., 10.0.0.0/16)"
}

variable "subnet_lb_cidr_24" {
  type        = string
  description = "IPv4 CIDR /24 block for the Load Balancer subnet, providing 256 addresses (e.g., 10.0.0.0/24)"
}

variable "subnet_api_endpoint_cidr_29" {
  type        = string
  description = "IPv4 CIDR /29 block for the Kubernetes API Endpoint subnet, providing 8 addresses (e.g., 10.0.1.0/29)"
}

variable "subnet_nodes_cidr_24" {
  type        = string
  description = "IPv4 CIDR /24 block for the Worker Nodes subnet, providing 256 addresses (e.g., 10.0.2.0/24)"
}

variable "subnet_pods_cidr_19" {
  type        = string
  description = "IPv4 CIDR /19 block for the Native Pods subnet, providing 8,192 addresses (e.g., 10.0.32.0/19)"
}
```

---

## Cluster Options

```hcl
variable "type_of_cluster" {
  type        = string
  description = "Type of cluster OKE: BASIC_CLUSTER or ENHANCED_CLUSTER"
  default     = "ENHANCED_CLUSTER"

  validation {
    condition     = contains(["BASIC_CLUSTER", "ENHANCED_CLUSTER"], var.type_of_cluster)
    error_message = "The value must be 'BASIC_CLUSTER' or 'ENHANCED_CLUSTER'"
  }
}

variable "cni_type" {
  type        = string
  description = "The CNI plugin type for the cluster (e.g., FLANNEL or OCI_VCN_IP_NATIVE)"
  default     = "OCI_VCN_IP_NATIVE"

  validation {
    condition     = contains(["FLANNEL", "OCI_VCN_IP_NATIVE"], var.cni_type)
    error_message = "The CNI type must be 'FLANNEL' or 'OCI_VCN_IP_NATIVE'"
  }
}
```

---

## Node Pool Configuration

```hcl
variable "pool_size" {
  type        = number
  description = "The number of worker nodes in the node pool."
  default     = 2

  validation {
    condition     = var.pool_size >= 0
    error_message = "The pool_size must be a non-negative integer."
  }
}

variable "pool_node_shape" {
  description = "The shape of the nodes in the node pool, defining the CPU and memory architecture."
  type        = string
  default     = "VM.Standard.E6.Flex"
}

variable "pool_node_image_id" {
  description = "The OCID of the image to be used for the nodes in the node pool."
  type        = string
}

variable "ocpus" {
  description = "The number of OCPUs to be assigned to each node when using a flexible shape."
  type        = number
  default     = 2
}

variable "memory_in_gbs" {
  description = "The amount of memory in GBs to be assigned to each node when using a flexible shape."
  type        = number
  default     = 16
}
```

---

# Example terraform.tfvars

```hcl
region                        = "sa-saopaulo-1"
compartment_id                = "ocid1.compartment.oc1..example"
cluster_name                  = "oke-demo"

vcn_cidr_block_16             = "10.6.0.0/16"
subnet_lb_cidr_24             = "10.6.0.0/24"
subnet_api_endpoint_cidr_29   = "10.6.3.0/29"
subnet_nodes_cidr_24          = "10.6.1.0/24"
subnet_pods_cidr_19           = "10.6.32.0/19"

type_of_cluster               = "ENHANCED_CLUSTER"
cni_type                      = "OCI_VCN_IP_NATIVE"

pool_size                     = 2
pool_node_shape               = "VM.Standard.E6.Flex"
pool_node_image_id            = "ocid1.image.oc1.sa-saopaulo-1.example"
ocpus                         = 2
memory_in_gbs                 = 16
```

---

# Deployment

```bash
terraform init
terraform plan
terraform apply
```

---

# Production Recommendations

* Restrict Kubernetes API endpoint CIDR access
* Remove SSH if not required
* Enable OKE audit logging
* Apply least-privilege IAM policies
* Integrate with WAF for internet-facing services

---

This repository translates Oracle’s official Example 3 networking architecture into modular, reusable Terraform code and provides a strong foundation for enterprise-grade OKE deployments.
