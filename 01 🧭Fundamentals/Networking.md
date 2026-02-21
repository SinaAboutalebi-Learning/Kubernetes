Kubernetes networking defines **how Pods communicate**, how traffic enters/exits the cluster, and how Services expose your workloads. It includes multiple layers: Pod networking, Services, kube-proxy, load balancing, and Ingress routing.

---

# 🧩 1. Kubernetes Services

A **Service** is a stable virtual endpoint that provides **load balancing**, **service discovery**, and **stable IPs** for accessing Pods.

Services solve:

- Pod IPs changing after restarts
- Need for a stable access point
- Load balancing across replicas

### How Services Work

- Services match Pods using **labels/selectors**
- kube-proxy programs **iptables** or **IPVS** rules
- A **ClusterIP (virtual IP)** is created
- Traffic load balances across backend Pods

### Virtual IP (ClusterIP)

- Allocated from **ClusterIP range**
- Works through kube-proxy rules
- Does NOT belong to a specific Pod or Node
- Is the foundation of both **iptables mode** and **IPVS mode**

---

# 📦 2. Service Types

### **1. ClusterIP (default)**

- Internal-only access
- Most common type
- Used for service-to-service communication

### **2. NodePort**

- Exposes a port on **every worker node**
- Works like:
    `NodePort -> Service Port -> Target Port (Pod)`
- NodePort range: `30000–32767`
- Used mostly when no LoadBalancer or without cloud provider

### **3. LoadBalancer**

- Gets an external/public IP
- Requires:
    - cloud provider integration **OR**
    - a load balancer like **MetalLB**
- Most “official” way to expose apps publicly

### **4. ExternalName**

- Creates a **CNAME** to an external DNS name
- No virtual IP
- Very rarely used → Ingress replaces this

---

# 🧊 3. Headless Services

A Service becomes **headless** when `clusterIP: None`.

Effects:

- ❌ No virtual IP
- ❌ No kube-proxy load balancing
- ✔️ DNS returns **individual Pod IPs**
- ✔️ Used heavily for **StatefulSets**, databases, clustering

**Example DNS record:**
`pod-0.myapp.default.svc.cluster.local
pod-1.myapp.default.svc.cluster.local`

---

# 🔀 4. Kube-Proxy, IPTables & IPVS

kube-proxy configures network rules so Services work.

### kube-proxy modes:

|Mode|How it Works|Notes|
|---|---|---|
|iptables|Layer 3/4 NAT rules for load balancing|Stable, slower for large clusters|
|IPVS|Kernel-level load balancing|Faster, recommended for large-scale|

Both modes use the **ClusterIP (VIP)** as the entry point.

Services = **smart traffic gateway** inside Kubernetes.

---

# 🌐 5. Networking Models

### **Pod IP Range**

- Each Pod gets its own IP
- Comes from the CNI plugin (Calico, Flannel, Cilium…)
### **ClusterIP Range**

- Separate range for Services (virtual IPs)

---

# 🔒 6. Network Policies

NetworkPolicy defines **L3/L4 firewall rules** between Pods.

- By default: **Everything can talk to everything**
- Policies allow:
    - Pod → Pod restrictions
    - Namespace → Namespace restrictions
    - Limited ingress/egress
- **Requires CNI support** (Calico, Cilium… Flannel does NOT support it alone)

---

# 🌍 7. Ingress — Smart L7 Routing

Ingress is an **HTTP reverse proxy** with:

- Host-based routing
- Path-based routing
- TLS termination
- Load balancing
- Session handling

Ingress is the **main production entrypoint** to Kubernetes.

Traffic flow:

`Internet → Ingress Controller → Services → Pods`

Ingress Controller examples:

- NGINX Ingress Controller
- Traefik
- HAProxy
- Istio Ingress Gateway (Service Mesh)

---

# 🛠️ 8. Port Forwarding

Used for debugging:

`kubectl port-forward pod/myapp 8080:80`

Allows you to reach a Pod locally without exposing it publicly.

---

# 🔌 9. CNI — Container Network Interface

CNI handles:

- Pod → Pod communication
- IPAM (IP allocation)
- Overlay networks (VXLAN)
- Underlay networks
- Routing

Common CNIs:

|CNI|Notes|
|---|---|
|Flannel|Simple, no NetworkPolicy|
|Calico|L3 routing, NetworkPolicy support|
|Cilium|eBPF-based, very fast|
|Weave|Mesh routing|

### Linux relies on:

- Network namespaces (each Pod = network namespace)
- veth pairs
- bridges / overlays
- routing tables

**Root namespace = node network**  
**Pod namespaces = isolated networks**

---

# 🧱 10. Special Networking Modes

### HostNetwork

- Pod uses the node’s network namespace.
- No isolation.
- Useful for:
    - low-level networking agents
    - DNS servers
    - monitoring/telemetry tools

### HostPort

- Exposes a port **only on one node**.
- Rarely used — prefer Services or DaemonSets.

---

# ✅ Final Clean Summary

**Kubernetes Networking includes:**

- Pod networking (CNI)
- Service networking (ClusterIP)
- Load balancing (kube-proxy, IPVS)
- North-South traffic (Ingress)
- Traffic security (NetworkPolicy)
- Debug tools (port-forward)

Services = **Internal Gateway**  
Ingress = **External Gateway**  
CNI = **Network Engine**  
NetworkPolicy = **Firewall**

---
# 🧠 Linking To Other Docs

To strengthen your knowledge base, link these topics:

- [[CNI]] → For Pod-to-Pod networking
- [[CoreDNS]] → For Service discovery & DNS
- [[Kube-Proxy]] → For iptables/ipvs load balancing
- [[Kubernetes Objects]] → Services, Endpoints, Pods
- [[StatefulSet]] → For headless services usage