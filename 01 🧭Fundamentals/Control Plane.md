# Kubernetes Control Plane

The **Control Plane** is the “brain” of a Kubernetes cluster.  
It makes global decisions about _what should happen_, _when it should happen_, and _how the cluster should behave_.

If the control plane is down → **the cluster can’t decide anything**, but _existing workloads keep running._

---
# 🧠 Components of the Control Plane

The control plane is made of **four major components**:

1. **kube-apiserver**
2. **etcd**
3. **kube-scheduler**
4. **kube-controller-manager**

And optionally:

5. **cloud-controller-manager** (only if using a cloud provider)

Let’s break them down.

---

# 1. kube-apiserver (The Front Door)

The **API Server** is the _only component_ that talks to etcd and the _central communication hub_.  
Everything — [[kubectl]], [[Controller Manager]], [[nodes]] — passes through the API server.

Functions:

- Validates & processes API requests
- Authn/Authz
- Talks to etcd
- Admission controllers
- Submits changes to cluster state

You can scale API servers horizontally because they’re **stateless**.

Internal links:  
→ [[Kubeconfig and AccessModel]]
→ [[etcd]]

---

# 2. etcd (The Brain’s Memory)

Everything Kubernetes knows is stored here.  
This is the **only stateful control-plane component**.

It provides:

- Cluster state storage
- RAFT-based quorum
- Strong consistency

If etcd breaks with no backup → your cluster is gone.

See: [[etcd]]

---

# 3. kube-scheduler (The Matchmaker)

The scheduler picks **which node** a pod should run on.

It considers:

- Resource requests/limits
- Node taints/tolerations
- Node labels & affinity rules
- Pod anti-affinity
- Workload distribution
- Custom scheduling plugins

It doesn't _run_ pods — it _assigns_ them.

Stateless.

See: [[Scheduler]]

---

# 4. kube-controller-manager (The Automated Fixer)

A bundle of controllers running as a single process:

- **Node Controller:** detects dead nodes
- **Replication Controller:** ensures desired replicas
- **Endpoint Controller:** builds Service endpoints
- **Namespace Controller:** cleans up resources on NS deletion
- **Service Account + Token Controllers**

Think of it as the cluster’s **autopilot**.

Stateless → multiple replicas supported.

See: [[Controller Manager]]

---

# 5. cloud-controller-manager (Optional)

Used in cloud-platform clusters:

- Manages cloud load balancers
- Node addresses/metadata
- Routes
- Persistent volumes (integration with cloud storage)

Often disabled in on-prem environments.

---
# 🧩 How Control Plane Components Interact

Here’s the conceptual diagram:
```
                      +----------------------+
                      |    kube-apiserver    |
                      |   (cluster gateway)  |
                      +----------+-----------+
                                 |
                                 | reads/writes
                                 v
                      +----------------------+
                      |         etcd         |
                      | (cluster state store)|
                      +-----------+----------+
                                  ^
            +---------------------|------------------------+
            |                     |                        |
            v                     |                        v
  +-------------------+     watches changes     +-----------------------+
  | kube-scheduler    |------------------------>| kube-controller-manager|
  | (assigns pods)    |                         |  (auto-fixes cluster)  |
  +-------------------+                         +------------------------+

```
This is the mental model Kubernetes itself uses internally.

---
# 🏗 Control Plane Node Layout

On a control plane node you typically have:

- [[Kube-apiserver]]
- [[Scheduler]]
- [[Controller Manager]]
- [[etcd]] (if not external)

Sometimes also:

- [[CRI]] (if node is also a worker)
- [[Kubelet]] (yes, masters also run kubelet)

---

# 🛡 HA Control Plane Overview

|Component|HA Method|Stateful?|
|---|---|---|
|API Server|Load balancer + replicas|No|
|Scheduler|Run >1 instance|No|
|Controller Manager|Run >1 instance|No|
|etcd|**Quorum (odd members)**|**Yes**|

Only etcd needs quorum.

Master nodes exist mainly because of etcd clustering.

More details in: [[etcd]]