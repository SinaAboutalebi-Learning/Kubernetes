CoreDNS is the **cluster DNS server** in Kubernetes.  
Every Pod and Service gets its own **DNS A record**, so workloads inside the cluster can discover each other without hardcoding IPs.

---

## 🧩 How DNS Records Look in Kubernetes

### **Service DNS Pattern**
```
<service>.<namespace>.svc.cluster.local

Example:
mysql.default.svc.cluster.local
```

### **Pod DNS Pattern**
```
<podname>.<namespace>.pod.cluster.local

Example:
web-5c7dfd4fdb-k2xvn.default.pod.cluster.local
```

### Why Pod DNS isn’t used often

Pods are ephemeral → their IP changes.  
Services get a **stable virtual IP**, so internal traffic should usually point to the service DNS name.


CoreDNS runs as a **Deployment** in the `kube-system` namespace and is exposed as a ClusterIP Service named `kube-dns`.

---
## 📤 External DNS / Upstream Resolvers

CoreDNS can forward unknown queries to external resolvers — e.g.:
- Google (8.8.8.8)
- Cloudflare (1.1.1.1)
- Your own internal DNS servers

Example CoreDNS snippet:

`forward . 1.1.1.1 8.8.8.8`

### Best practice

Cluster resolution **must happen first** → external only when no internal match is found.

---
## 🧱 Performance & Scaling Considerations

In small clusters, CoreDNS barely sweats.  
But in large clusters, DNS becomes a choke point because:

- Every pod startup triggers DNS lookups
- Every service lookup hits CoreDNS
- Misconfigured applications hammer DNS with retries
- Job-heavy workloads cause DNS spikes

### What matters at scale:

- **Autoscaling** CoreDNS Deployment
- **Increasing resources** (CPU > memory)
- Storing logs in a centralized system (ELK, Loki, etc.)
- DNSTap or query logging for debugging

---
## 🔧 Troubleshooting CoreDNS

There are several ready-made pods for DNS debug:

### 1. **dnsutils / busybox**

`kubectl run -it dns --image=busybox:1.36 -- sh nslookup kubernetes.default`

### 2. k8s.gcr.io/e2e-test-images/jessie-dnsutils

`kubectl run -it dnsutils --image=k8s.gcr.io/e2e-test-images/jessie-dnsutils:1.3 -- bash dig kubernetes.default.svc.cluster.local`

### 3. **Check CoreDNS logs**

`kubectl logs -n kube-system -l k8s-app=kube-dns`
### 4. **Check CoreDNS config**

`kubectl -n kube-system get configmap coredns -o yaml`

---
## 📝 Example CoreDNS Config

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough in-addr.arpa ip6.arpa
        }
        forward . 1.1.1.1 8.8.8.8
        cache 30
        loop
        reload
        loadbalance
    }

```