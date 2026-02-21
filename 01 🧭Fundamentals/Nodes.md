A **Node** is any machine where the **[[Kubelet]]** is installed.  
Simple rule:

`If kubelet runs on it → it’s a Node.`

Nodes can be:

- **Worker nodes** → run your workloads (Pods)
- **Control plane nodes / masters** → run Kubernetes brain components  
    ([[Kube-apiserver]], [[Scheduler]], [[Controller Manager]], [[etcd]])

### 🧩 Node Components (quick summary)

- **kubelet** → talks to API server, runs pods, reports node status
- **container runtime** → containerd, CRI-O
- **kube-proxy** → networking rules for Services