Kubernetes has baked-in defaults that matter when planning node size and cluster topology.

**Default upper limits:**

- ~110 Pods per node (Kubernetes default for kubelet)
- ~5,000 nodes per cluster
- ~150,000 total Pods
- ~300,000 total containers

These aren’t hard physics limits, but they’re the safe, documented thresholds where control-plane components stay healthy.

---

## Node Size Choices

Node capacity affects reliability, downtime cost, and operational overhead.

### Super Nodes (large, high-capacity nodes)

**Pros**

- Fewer nodes → lower operational overhead (fewer upgrades, fewer drains, fewer patch cycles)
- Better cost efficiency per node
- Can host heavyweight workloads that need big CPU or RAM chunks
- Easier to pack workloads with bin-packing strategies

**Cons**

- High downtime impact: if a super node dies, dozens or hundreds of Pods vanish at once
- Pod density increases scheduling pressure and recovery churn
- Single point failure domains become too big

**Best for**

- Compute-intensive apps (AI workloads, large DB-backed operators, analytics pipelines)
- Clusters with strong PodDisruptionBudgets and quick autoscaling recovery

---

### Small Nodes (lightweight nodes with fewer resources)

**Pros**

- Low blast radius → a node failure barely affects the cluster
- More granular scaling; autoscaler reacts gently
- Good for microservices and stateless workloads

**Cons**

- Many nodes → more maintenance
- Higher node count means higher cost and more load on control-plane components
- Hard to run very large apps that require big chunks of CPU/RAM

**Best for**

- Stateless microservices
- Latency-sensitive or HA workloads
- Environments where node failures shouldn’t affect many Pods

---

## Balanced Strategy: Mixed-Size Node Pool

The most effective approach is to **use both types of nodes** inside the same cluster:

- **Super nodes** for heavyweight, batch, or compute-hungry apps
- **Small nodes** for general microservices, API apps, background workers, cron jobs
- Separate them with **node labels**, **affinity rules**, and **taints/tolerations** so workloads land where they belong
- Use **multiple node pools** with their own autoscaling logic

This gives:

- Flexibility in workload placement
- Lower total cost
- Reduced blast radius per failure
- Capacity for heavy apps without burning the entire cluster
- Smarter scheduling and better efficiency

---

A mixed topology is the closest thing Kubernetes has to “biome engineering.” Heavy creatures roam the super nodes; small mammals scurry across the small nodes. The ecosystem becomes stable because it supports many kinds of life.