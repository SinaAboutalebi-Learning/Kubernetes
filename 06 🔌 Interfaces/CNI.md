# Container Network Interface

Kubernetes also doesn’t ship with its own networking system.  
It uses **CNI** → a standard for configuring pod network interfaces.

CNI is used whenever a pod is created → the CNI plugin attaches the pod to the cluster network.

### Examples of CNI Plugins

- **Calico** (networking + network policies)
- **Flannel** (simple overlay network)
- **Cilium** (eBPF-based, super powerful)
- **Weave Net**
- **Kube-Router**

### What CNI Does

- Assigns Pod IPs
- Creates Pod network interfaces
- Handles routing inside the cluster
- Implements network policies (if supported)

### Diagram
```
[ Pod Creation ]
        |
        v
  [ Kubelet ]
        |
        v
   Calls CNI
        |
        v
[ CNI Plugin ] ----> sets up network namespace, veth, routing

```
