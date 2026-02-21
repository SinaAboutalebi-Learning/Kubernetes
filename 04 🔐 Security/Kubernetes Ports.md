Knowing ports helps with:

- Firewall rules
- Debugging connectivity issues
- Security audits

#### **Node Ports**

- `10250/tcp` → kubelet (API access)
- `10256/tcp` → kube-proxy
- `30000–32767/tcp` → NodePort services

#### **Control Plane (Master) Ports**

- `6443/tcp` → kube-apiserver
- `2379–2380/tcp` → etcd
- `10250/tcp` → kubelet
- `10259/tcp` → kube-scheduler
- `10257/tcp` → controller-manager

**Tip**  
These ports must be **explicitly allowed** during installation.

**Links**

- [[Kubernetes Installation]]
- [[Kubernetes Security]]