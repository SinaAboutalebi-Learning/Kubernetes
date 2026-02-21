# Node HA Design

Goal: avoid single points of failure (SPOF) for components that must stay available.  
Design around **redundancy**, **odd-numbered quorums**, **isolation**, and **automated failover**.

---

## Strong recommendations (summary)
- etcd: run an odd quorum (3 minimum; 5 for larger clusters).  
- Control plane: 3 control-plane nodes (active-active API servers; controller-manager & scheduler run leader-elected HA).  
- Workers: 3+ worker nodes (minimum); scale based on capacity and failure domain requirements.  
- API server: place behind a highly available load balancer (VIP + HA pair or cloud LB).  
- Backup etcd regularly and test restores.

---

## etcd
- **Quorum**: uses Raft. Use an odd number of members (3 minimum).  
- **Placement**: co-locating etcd with control-plane nodes is common, but dedicated machines or external managed etcd are preferred for production.  
- **Backups**: automated snapshots + off-site retention.  
- **Networking**: ensure low-latency, reliable links between members—split-brain risk increases with latency.

---

## API Server
- **Stateless & active-active**: you can run many kube-apiserver instances concurrently.  
- **Load Balancer**: front the API servers with a load balancer. The LB itself is a potential SPOF unless made HA:
  - Use two HA load balancers with a Virtual IP (VIP) using keepalived + HAProxy, or
  - Use cloud-managed LBs, or
  - Use anycast/VPN-based solutions for production-grade HA.
- **Note**: API servers talk to etcd; ensure LB directs to healthy API servers only.

---

## Controller Manager & Scheduler
- **Leader election (active-passive)**: run multiple instances, but only one leader is active at a time.  
- **High availability**: deploy at least 2–3 replicas so leader failover is instantaneous.

---

## Workers
- **Minimum**: keep at least 3 worker nodes for basic resilience and Pod distribution.  
- **Anti-affinity and PodDisruptionBudgets**: use these to preserve availability when nodes fail or are drained.

---

## Load Balancer HA patterns
- **Keepalived + HAProxy**: classic on-prem approach — two LB nodes share a VIP via keepalived; HAProxy routes to API servers.  
- **External/Cloud LB**: use cloud LBs when possible (managed HA + global endpoints).  
- **CDN / Global LB**: useful for multi-region clusters (but more complex).

---

## Avoiding SPOF across components
- etcd replica loss → cluster read-only or fail. Keep odd quorum and backups.  
- Single LB → create redundant LBs + VIP or use cloud LB.  
- Single control-plane node → run >=3 control-plane nodes.  
- Single region → design for region failures if needed (multi-AZ or multi-region).

---

## Extras & operational best practices
- **Regular HA drills**: simulate node failures and restore tests.  
- **etcd snapshot + restore runbooks**: automated and tested.  
- **Monitoring & alerting**: etcd health, control-plane P90 latency, kube-apiserver error rates.  
- **Immutable infra**: use IaC (Terraform / Ansible / kubeadm config) to recreate control plane predictably.  
- **Network design**: ensure control-plane nodes share fast links; consider separate mgmt network for control-plane comms.

---

## Related
- [[etcd]]
- [[Kube-apiserver]]
- [[Load Balancing]]
- [[Auditing]]
- [[Backup & Restore]]
