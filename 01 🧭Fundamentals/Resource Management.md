Kubernetes lets you control how much CPU and memory each pod can *request* and *consume*. 
Correct resource settings improve cluster stability, scheduling accuracy, and fairness.

---

## Requests (min)
A **request** is the minimum amount of CPU/Memory guaranteed for a container.

- The scheduler uses requests to decide **which node** can host the pod.
- Kubernetes guarantees that this much resource will always be available.
- If `request = limit`, the pod gets a *guaranteed* quality-of-service (QoS) class.

---

## Limits (max)
A **limit** is the maximum CPU/Memory the container is allowed to use.

- If the app uses more than the memory limit → **OOMKill**.
- If it tries to use more CPU → throttling happens.

Limits prevent a single pod from hogging the node.

---

## QoS (Quality of Service) Classes
Kubernetes automatically assigns one of three QoS classes based on how you set requests/limits.

### 1) Guaranteed
Rules:
- Every container in the pod has **request = limit** for both CPU and memory.

Effects:
- Highest priority under pressure.
- Last to be evicted.

Best for:
- Critical workloads.

---

### 2) Burstable
Rules:
- Requests and limits are set **but not equal**.

Effects:
- Normal priority.
- Can burst above request until reaching limit.

Best for:
- Apps with variable or spiky usage.

---

### 3) BestEffort
Rules:
- No requests or limits *at all*.

Effects:
- Lowest priority.
- First to be evicted.
- Scheduler doesn’t reserve anything → noisy-neighbor problems.

Almost never recommended for production unless intentionally sandboxing something.

---

## Why Always Set Requests and Limits?
Leaving them unset is like sending someone to a buffet without any plate size specified.  
The node will eventually cry.

Setting them ensures:
- Reliable scheduling
- Balanced nodes
- Predictable performance
- Reduced eviction risk

---

## Node-Level Protection: kube-reserved & system-reserved
Nodes themselves need CPU/Memory for:
- OS processes (systemd, journald…)
- Kubelet
- Runtime (e.g. containerd)
- CNI agents
- CSI agents

You can configure:
```yaml
kube-reserved:
cpu: "200m"
memory: "512Mi"

system-reserved:
cpu: "300m"
memory: "512Mi"
```

These settings ensure the node **never gives away all its resources to pods**, preventing OS instability or kubelet crashes.

---

## Pod Overhead
Some workloads (especially with virtualized network interfaces or sandboxed runtimes) require extra resources.

Pod overhead accounts for:
- Network namespace
- Additional sandboxes
- Runtime wrappers (e.g., Kata Containers, gVisor)

Kubernetes adds this overhead on top of the container requests.

Useful when:
- Using virtualized runtimes
- Running advanced CNI plugins
- Pods restart and briefly spawn an “overhead pod” to prepare networking

---

## Related
- [[Scheduler]]
- [[Kubelet]]
- [[Deployment]]
