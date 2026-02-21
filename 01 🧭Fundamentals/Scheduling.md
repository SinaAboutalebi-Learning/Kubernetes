Scheduling in Kubernetes is the process of deciding **which node** should run each pod.  
The scheduler takes a pod → runs it through filters and scoring rules → produces a “pod-to-node” decision.

You can reshape this scheduling flow using selectors, affinities, taints, priorities, and disruption rules.

---

## NodeSelector
The simplest scheduling rule.

Attach a label to a node:

node:
  labels:
    role: frontend

Specify in the pod:

spec:
  nodeSelector:
    role: frontend

This forces the pod onto nodes matching `key=value`.  
It’s basic, rigid, and not very flexible.

---

## NodeName
Direct pod-to-node pinning:

spec:
  nodeName: mynode01

This bypasses the scheduler entirely.  
Useful only in very specific scenarios.

---

## Node Affinity / Anti-Affinity
A more expressive successor to NodeSelector.

### Node Affinity
Describes **which nodes a pod should run on**, using label expressions.

Modes:
- `requiredDuringSchedulingIgnoredDuringExecution` → hard requirement  
  If the rule cannot be satisfied, the pod **won’t schedule**.
- `preferredDuringSchedulingIgnoredDuringExecution` → soft preference  
  Scheduler tries, but won’t block startup.

Example use case:
- All frontend pods must run on nodes labeled `tier=frontend`.
- Or: prefer SSD-enabled nodes.

### Node Anti-Affinity
Specifies nodes where the pod **should NOT** run.

Example:
- Keep your cache service away from nodes that run heavy workloads.

---

## InterPodAffinity / InterPodAntiAffinity
This works like affinity but on *pod* level instead of nodes.

### InterPodAffinity
Defines that a pod should run **close to other pods**.

Example:
- Run frontend pods **on the same nodes** as backend pods for locality.

### InterPodAntiAffinity
Defines that pods should **not** be co-located.

Example:
- Spread replicas across nodes so one node failure doesn’t kill all replicas.

Note:
Using too many affinity rules makes scheduling more restrictive and may cause scheduling failures.

---

## Taints & Tolerations
Taints are applied on nodes.  
Tolerations are applied on pods.

A tainted node repels all pods unless the pod tolerates it.

Example:
Node:
  taints:
    - key: dedicated
      value: payments
      effect: NoSchedule

Pod:
  tolerations:
    - key: "dedicated"
      value: "payments"
      operator: "Equal"
      effect: "NoSchedule"

Use cases:
- Dedicated hardware
- GPU nodes
- NoSchedule worker pools  
- Blocking general workloads from special-purpose nodes

---

## Priority Classes
Priority determines which pods matter more under resource pressure.

Higher number = higher priority.

Kubernetes includes built-in priority classes (for system components).  
If a high-priority pod cannot schedule because nodes are full:

→ Scheduler tries **preemption**.  
It evicts lower-priority pods to create space.

DaemonSets effectively have the highest scheduling priority because they must run on every node.

---

## Eviction
Pods may be evicted due to:
- Hardware/node failure
- Admin `kubectl drain`
- Node pressure (memory, disk, PID)

Eviction triggers pod rescheduling elsewhere.

---

## Pod Disruption Budget (PDB)
Defines how many replicas of an application **must remain available** during disruptions.

Useful when:
- Draining nodes
- Doing rolling updates
- Protecting quorum-based systems

Examples:
- `minAvailable: 2`
- `maxUnavailable: 1`

---

## Bin Packing
Kubernetes sometimes packs multiple pods tightly onto a node to make room elsewhere.  
This helps:
- Global resource efficiency
- Making room for high-priority pods
- Reducing fragmentation

It’s a natural part of preemption and scheduling optimizations.

---

## Related
- [[Resource Management]]
- [[ReplicaSet]]
- [[DaemonSet]]
- [[Scheduler]]