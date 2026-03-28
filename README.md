# OCI OKE Infrastructure as Code – Reference Implementation

[![Terraform Validate](https://github.com/jefersonferr/oke-cluster-tf/actions/workflows/terraform-validate.yml/badge.svg)](https://github.com/jefersonferr/oke-cluster-tf/actions/workflows/terraform-validate.yml)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![OCI Provider](https://img.shields.io/badge/OCI_Provider-%3E%3D6.0.0-F80000?logo=oracle&logoColor=white)](https://registry.terraform.io/providers/oracle/oci/latest)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

## Overview

This repository provides a Terraform-based reference implementation to provision a complete Kubernetes environment on **Oracle Cloud Infrastructure (OCI)** using **Oracle Kubernetes Engine (OKE)**.

The implementation covers all four networking scenarios defined in the official Oracle documentation, selectable through two configuration variables:

| Scenario | CNI Plugin | API Endpoint | Oracle Documentation |
|----------|-----------|-------------|----------------------|
| Example 1 | Flannel | Public | [Link](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-flannel-cni-publick8sapi_privateworkers_publiclb) |
| Example 2 | Flannel | Private | [Link](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-flannel-cni-privatek8sapi_privateworkers_publiclb) |
| Example 3 | OCI VCN-Native | Public | [Link](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-oci-cni-publick8sapi_privateworkers_publiclb) |
| Example 4 | OCI VCN-Native | Private | [Link](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-oci-cni-privatek8sapi_privateworkers_publiclb) |

Official reference: [Example Network Resource Configurations](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm)

---

## Scenario Selection

The scenario is determined by two variables:
```hcl
cni_type               = "OCI_VCN_IP_NATIVE"  # or "FLANNEL"
is_api_endpoint_public = true                   # or false
```

All networking resources — subnets, route tables, security lists, and gateways — are automatically adjusted based on these two choices. No manual editing of security rules or route tables is needed.

---

## Architecture Summary

All four scenarios share a common foundation: a VCN with Internet Gateway, NAT Gateway, Service Gateway, private worker nodes, and public load balancers. The differences are:

### CNI Plugin axis

**Flannel (Examples 1 and 2):**
- Pods use an overlay network and share the worker node IP addresses.
- Three subnets are created: Load Balancer, API Endpoint, and Worker Nodes.
- Worker nodes route through NAT Gateway + Service Gateway.
- Pod-to-pod communication rules are applied on the worker nodes subnet.

**OCI VCN-Native (Examples 3 and 4):**
- Pods receive native VCN IP addresses from a dedicated subnet.
- Four subnets are created: Load Balancer, API Endpoint, Worker Nodes, and Pods.
- Worker nodes route through Service Gateway only (no NAT).
- Pods subnet routes through NAT Gateway + Service Gateway.
- Dedicated security list controls pod ingress and egress.

### API Endpoint axis

**Public (Examples 1 and 3):**
- API endpoint subnet is public, routed through Internet Gateway.
- A public IP is assigned to the Kubernetes API endpoint.
- Security list allows ingress on port 6443 from `0.0.0.0/0`.

**Private (Examples 2 and 4):**
- API endpoint subnet is private, routed through NAT Gateway + Service Gateway.
- No public IP is assigned.
- Access to the API endpoint requires VPN, peering, or OCI Bastion.

---

## Infrastructure Components

### Networking (all scenarios)

- VCN (`/16`)
- Internet Gateway
- NAT Gateway
- Service Gateway
- Public Route Table (Internet Gateway)
- Private Route Table (NAT + Service Gateway)
- Dedicated Security Lists per subnet

### Subnets

| Subnet | CIDR | Visibility | Created |
|--------|------|-----------|---------|
| Load Balancer | `/24` | Public | Always |
| API Endpoint | `/29` or `/30` | Public or Private | Always |
| Worker Nodes | `/24` | Private | Always |
| Pods | `/19` | Private | VCN-Native CNI only |

### Additional resources (conditional)

| Resource | Condition |
|----------|-----------|
| Service-only Route Table (SG without NAT) | VCN-Native CNI |
| Pods Security List | VCN-Native CNI |
| Pods Subnet | VCN-Native CNI |

---

## OKE Configuration

### Cluster

- Type: `BASIC_CLUSTER` or `ENHANCED_CLUSTER`
- CNI: `FLANNEL` or `OCI_VCN_IP_NATIVE`
- API endpoint: public or private
- Dedicated endpoint subnet
- Service LB subnet configured

### Node Pool

- Configurable shape (Flex shapes with custom OCPU and memory)
- Worker nodes deployed in private subnet
- Pod subnet attached when using VCN-Native CNI
- Configurable node count

---

## Repository Structure
```
.
├── main.tf              # Root module — orchestrates all resources with conditional logic
├── variables.tf         # Input variables
├── outputs.tf           # Outputs including selected scenario description
├── provider.tf          # OCI provider configuration
├── schema.yaml          # ORM Console form definition with conditional visibility
├── CONTRIBUTING.md      # Contribution guidelines
├── LICENSE              # Apache License 2.0
├── examples/            # tfvars examples for all 4 scenarios
│   ├── example1-flannel-public.tfvars.example
│   ├── example2-flannel-private.tfvars.example
│   ├── example3-vcn-native-public.tfvars.example
│   └── example4-vcn-native-private.tfvars.example
├── .github/workflows/
│   └── terraform-validate.yml   # CI pipeline (fmt + validate)
├── modules/
│   ├── vcn/                     # Virtual Cloud Network
│   ├── internet_gateway/        # Internet Gateway
│   ├── network_gateway/         # NAT Gateway
│   ├── service_gateway/         # Service Gateway
│   ├── default_route_table/     # Default (public) route table
│   ├── route_table/             # Custom route tables
│   ├── default_security_list/   # Default security list (used by LB subnet)
│   ├── security_list/           # Custom security lists
│   ├── subnet/                  # Subnet
│   ├── oke_cluster/             # OKE Cluster
│   └── oke_node_pool/           # OKE Node Pool
```

Each module contains its own `README.md` with auto-generated documentation of inputs, outputs, and resources.

---

## Deployment

### Option 1: OCI Resource Manager (ORM)

This repository includes a `schema.yaml` that provides a guided form experience in the ORM Console. The form dynamically adjusts based on your selections — for example, the Pods Subnet CIDR field is only shown when the CNI is set to OCI VCN-Native.

1. In the OCI Console, navigate to **Developer Services → Resource Manager → Stacks**.
2. Create a new stack from a ZIP file or GitHub repository URL.
3. Fill in the form fields — the scenario is determined by the **CNI Plugin** and **Public Kubernetes API Endpoint** selections.
4. Run **Plan** to review the resources that will be created.
5. Run **Apply** to provision the infrastructure.

For detailed deployment instructions, see [oci-deployment.md](oci-deployment.md).

### Option 2: Terraform CLI
```bash
cp examples/example3-vcn-native-public.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

terraform init
terraform plan
terraform apply
```

Complete `.tfvars.example` files for all four scenarios are available in the [`examples/`](examples/) directory.

---

## Outputs

After a successful apply, the stack outputs the following:

| Output | Description |
|--------|-------------|
| `scenario_description` | Human-readable description of the selected scenario (e.g., "Example 3 — OCI VCN-Native CNI, Public Kubernetes API Endpoint") |
| `cluster_id` | OCID of the OKE cluster |
| `vcn_id` | OCID of the VCN |
| `subnet_api_endpoint_id` | OCID of the API endpoint subnet |
| `subnet_nodes_id` | OCID of the worker nodes subnet |
| `subnet_lb_id` | OCID of the load balancer subnet |
| `subnet_pods_id` | OCID of the pods subnet (null when using Flannel) |

---

## Production Recommendations

- Restrict Kubernetes API endpoint access to specific CIDRs instead of `0.0.0.0/0`
- Remove SSH ingress rule (port 22) if not required
- Enable OKE audit logging
- Apply least-privilege IAM policies
- Integrate with WAF for internet-facing services
- Consider using Network Security Groups (NSGs) in addition to security lists for finer-grained control

---

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to submit issues and pull requests.

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

---

## References

- [OKE Network Resource Configuration Examples](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm)
- [ORM Schema Configuration](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/terraformconfigresourcemanager_topic-schema.htm)
- [OKE Worker Node Images](https://docs.oracle.com/en-us/iaas/images/oke-worker-node-oracle-linux-8x/index.htm)