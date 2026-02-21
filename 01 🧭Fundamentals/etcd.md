**etcd** is a distributed, reliable **key-value store**, written in Go.  

It stores EVERYTHING Kubernetes needs to function:
- Cluster state
- Configs
- Secrets
- Workload definitions
- Node objects, pod specs, service objects
- RBAC info

If etcd dies with no backup →  
**your entire cluster forgets it ever existed.**
No joke.

## 🧠 etcd is _the ONLY_ Stateful Component

All other control plane components (scheduler, controller-manager, API server) are stateless.  
They _rebuild their state_ by reading from etcd.

This is why:
- etcd must be HA
- etcd must be backed up
- etcd must be protected
- API server only talks to etcd

---
# 🔄 etcd High Availability

etcd uses the **Raft** consensus algorithm.

### 📌 Raft Leader Election Formula

`Quorum = (N/2) + 1`

Where **N** = total number of etcd members.

Examples:

|Members|Quorum Needed|Notes|
|---|---|---|
|1|1|not HA|
|2|2|bad — no failure tolerance|
|3|2|good|
|5|3|best practice|

Odd numbers are always used.

---
# 🧩 Why Control Plane Nodes Need Quorum

The **only reason** Kubernetes requires multiple master/control-plane nodes is:

👉 **etcd quorum**

Everything else is stateless and can run with as many replicas as you want.

So you can keep masters minimal _if_ you use **external etcd**.

---
# 🌐 External etcd (When & Why)

You can run etcd on a **separate cluster** instead of on control-plane nodes.

Benefits:

- Decreases number of master nodes
- Better isolation and security
- Easier backups
- You can upgrade/move Kubernetes control plane independently

Kubernetes clusters in big enterprises often use **dedicated etcd clusters**.

---
# 💾 etcd Backups (EXTREMELY IMPORTANT)

Trusted commands:

Backup:

`ETCDCTL_API=3 etcdctl snapshot save snapshot.db`

Restore:

```bash
ETCDCTL_API=3 etcdctl snapshot restore snapshot.db \ 
   --name=etcd-1 \ 
   --initial-cluster=etcd-1=https://1.2.3.4:2380 \
   --initial-cluster-token=etcd-cluster-1 \    
   --initial-advertise-peer-urls=https://1.2.3.4:2380
```

Always backup:

- before upgrades
- before adding/removing control plane nodes
- periodically (automated)