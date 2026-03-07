
# OKE Cluster Deployment with OCI Resource Manager and Terraform

This project demonstrates how to deploy a Kubernetes cluster using Terraform and Oracle Cloud Infrastructure (OCI) Resource Manager.

The infrastructure is provisioned using Infrastructure as Code (IaC) and executed directly from the OCI console using a GitHub repository as the Terraform source.

The deployment creates an Oracle Kubernetes Engine (OKE) cluster and supporting infrastructure such as networking and node pools.

---

# Architecture Overview

The solution provisions a complete Kubernetes environment in Oracle Cloud Infrastructure using Terraform automation.

The deployed architecture typically includes:

- Virtual Cloud Network (VCN)
- Public and private subnets
- Internet Gateway
- Security Lists / Network Security Groups
- Oracle Kubernetes Engine cluster
- Node Pools (worker nodes)
- Load Balancer for applications

Infrastructure provisioning is executed through OCI Resource Manager, which runs Terraform jobs directly inside OCI.

---

# Repository

Terraform code used in this guide is available at:

Repository:
https://github.com/jefersonferr/oke-cluster-tf

Typical Terraform files included:

main.tf
variables.tf
outputs.tf
provider.tf
versions.tf

These files define the required OCI resources and configuration parameters for the Kubernetes cluster.

---

# Prerequisites

Before starting, ensure the following requirements are met.

## OCI Requirements

- OCI tenancy
- Compartment for deployment
- Permissions to create resources

## Local Requirements

- Git
- kubectl
- OCI CLI (optional)

---

# Step 1 — Configure GitHub Source Provider

OCI Resource Manager can retrieve Terraform configurations directly from GitHub repositories.

Navigate to:

OCI Console → Developer Services → Resource Manager → Source Providers

Create a new provider:

1. Click Create Source Provider
2. Select GitHub
3. Authenticate your GitHub account
4. Grant repository access

Once configured, Resource Manager can clone repositories and execute Terraform jobs.

---

# Step 2 — Create a Stack from GitHub

Create a stack referencing the Terraform code.

Navigate to:

Developer Services → Resource Manager → Stacks → Create Stack

Choose:

Source Code Control System

Then configure:

- Source Provider: GitHub
- Repository: oke-cluster-tf
- Branch: main
- Working Directory: /

Click **Create Stack**.

The Terraform configuration will be downloaded automatically.

---

# Step 3 — Edit Terraform Code (Optional)

OCI Resource Manager provides a built‑in Terraform Code Editor.

This editor allows users to:

- modify Terraform variables
- update resource parameters
- customize cluster configuration
- test infrastructure changes

Common files that may be edited include:

variables.tf
terraform.tfvars
main.tf

---

# Step 4 — Run Terraform Plan

The Plan action previews infrastructure changes.

Steps:

1. Open the stack
2. Click Terraform Actions
3. Select Plan

Example output:

Plan: 10 to add, 0 to change, 0 to destroy

---

# Step 5 — Apply the Terraform Configuration

After reviewing the plan:

Terraform Actions → Apply

OCI Resource Manager will execute the deployment.

Resources created may include:

- VCN
- Subnets
- OKE cluster
- Node pools
- Security components

---

# Step 6 — Verify the OKE Cluster

Navigate to:

Developer Services → Kubernetes Clusters (OKE)

You should see:

- the new cluster
- node pools
- worker nodes

Expected status:

ACTIVE

---

# Step 7 — Connect Using Cloud Shell

Open the cluster page and go to Quick Start.

Run the command:

```
oci ce cluster create-kubeconfig --cluster-id <cluster_ocid> --file $HOME/.kube/config --region <region> --token-version 2.0.0
```

Verify connectivity:

```
kubectl version --short
```

---

# Step 8 — Deploy Sample Application

Deploy a sample application:

```
kubectl create deployment sample-app --image=nginx
```

Expose the application:

```
kubectl expose deployment sample-app --type=LoadBalancer --port=80
```

---

# Step 9 — Inspect Kubernetes Resources

List cluster nodes:

```
kubectl get nodes
```

List pods:

```
kubectl get pods -o wide
```

List deployments:

```
kubectl get deployments
```

List services:

```
kubectl get services
```

---

# Step 10 — Destroy Infrastructure

Navigate to:

Resource Manager → Stacks

Select the stack and execute:

Terraform Actions → Destroy

Terraform will delete all resources created during the deployment.

---

# Advantages of Using Infrastructure as Code

Automation – Infrastructure deployment without manual steps.

Repeatability – Infrastructure environments recreated consistently.

Version Control – Infrastructure stored in Git repositories.

DevOps Integration – Integration with CI/CD pipelines.

---

# Conclusion

This guide demonstrated the full lifecycle of deploying a Kubernetes cluster using Terraform and OCI Resource Manager.

The process included:

- configuring a GitHub source provider
- creating a stack from a Terraform repository
- executing Terraform Plan and Apply
- deploying an OKE cluster
- connecting using Cloud Shell
- deploying a Kubernetes application
- inspecting cluster resources
- destroying infrastructure

By combining Terraform, GitHub, and OCI Resource Manager, teams can implement a modern Infrastructure as Code workflow that accelerates cloud adoption and improves operational consistency.
