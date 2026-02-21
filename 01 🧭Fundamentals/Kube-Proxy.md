Responsible for Kubernetes **Service** networking.

- Implements **virtual IPs (ClusterIP)**
- Runs as a **DaemonSet** → so it exists on _every node_


Kube-proxy modes:

- iptables
- IPVS (faster)