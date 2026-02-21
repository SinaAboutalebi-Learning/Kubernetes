
# Kubeadm

`kubeadm` is the **official Kubernetes installation tool**.

- Used by:
    - `kubeadm` itself
    - `kind` (single-node clusters)

**Minimum requirements**

- `2 CPU / 2 GB RAM`
- **Swap must be disabled**
- `ip_netfilter` & bridge networking enabled
- Container runtime installed (containerd, CRI-O, etc.)
- Proper **cgroup driver configuration**

**Installation flow**

1. Allow required ports
2. Install container runtime
3. Pull Kubernetes images
4. Initialize control plane
5. Install CNI
6. Join worker nodes

## Kubespray

**Production-grade Kubernetes installation using Ansible**

**Why Kubespray is popular**

- Production-ready & battle-tested
- Supports:
    - Multiple CNIs
    - Cloud providers
    - Different CRIs
- Highly configurable
- Scales well for HA clusters

**Best use case**  
When you want:

- Repeatable installs
- Infrastructure-as-code
- Large or multi-node clusters

## Kubernetes Operations

Operational focus areas:

- Upgrades
- Scaling
- Monitoring
- Security patches
- High availability

Production Kubernetes is not “set and forget”.  
It’s closer to **running a distributed operating system**.


## High Availability Kubernetes

Production-ready Kubernetes requires:

- Multiple control plane nodes
- etcd redundancy
- Load-balanced API server
- Reliable networking

Avoid single points of failure — especially the control plane.


## Rancher

Rancher provides **Kubernetes as a Service**.

**Key features**

- Multi-cluster management
- Fully containerized
- Vendor independent
- CNCF certified

**Use case**  
Ideal for:

- Managing many clusters
- Centralized access control
- Simplified operations

**Links**

- [[CNI]]
- [[Kubernetes Ports]]
- [[Kubernetes Versioning]]