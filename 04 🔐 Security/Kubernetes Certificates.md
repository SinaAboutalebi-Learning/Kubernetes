All Kubernetes components communicate using **TLS certificates**.

- Certificates are stored in:  
    `/etc/kubernetes/pki`

- Used for:    
    - API server ↔ kubelet
    - API server ↔ etcd
    - Controller manager, scheduler, etc.

This ensures **mutual authentication** between cluster components.

**Why this matters**  
If certificates expire or are misconfigured:

- Nodes fail to join
- API calls fail
- Cluster appears “healthy” but stops working

**Links**

- [[Kubernetes Ports]]
- [[Kubernetes Installation]]