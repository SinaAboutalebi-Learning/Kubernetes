Kubernetes objects are the building blocks of everything in a cluster. They describe the desired state of your applications, workloads, networking, and configuration. Every higher-level resource ultimately creates or manages **Pods**, which are the smallest deployable unit in Kubernetes.

---

# 🧩 1. Pods — The Smallest Object in Kubernetes

- A **Pod** is the smallest Kubernetes object you can create or manage.
- Kubernetes **cannot manage anything below a Pod**. Containers inside a Pod are not individually schedulable.
- A Pod may contain:
    - **One or more containers**
    - **Init containers** (run first, finish, then main containers start)
    - Shared storage/network namespaces

### What Pods Solve

Pods allow containers to:
- share localhost
- share volumes
- start in order
- restart together

---

# 🏗️ 2. Pod Templates

Higher-level controllers (like Deployments, ReplicaSets, Jobs, DaemonSets) define **Pod templates**, which contain everything needed to create identical Pods:

- image
- environment variables
- volumes
- container lifecycle events
- labels & annotations

Whenever scaling happens, Kubernetes **creates new Pods based on this template**.

---

# 💻 3. Static Pods

Static Pods are:

- Created **directly by the [[kubelet]]**, NOT by the [[Kube-apiserver]]
- Managed using manifest files placed in a directory (usually `/etc/kubernetes/manifests/`)
- Useful for:
    - Bootstrapping [[Control Plane]] components on a node
    - Testing without a running [[Control Plane]]
    - Ensuring critical processes exist even if the cluster is broken

**Key feature:**  
Even if there is _no_ API server or cluster roles defined, kubelet will still run static pod manifests.

---

# 🔄 4. Pod Lifecycle

Pods transition through several phases:
```
Pending → Running → Succeeded | Failed | Unknown
```

### What each phase means:

- **Pending**  
    Pod is accepted by Kubernetes but images are still pulling or resources aren’t allocated yet.
- **Running**  
    Pod has been scheduled and containers are executing.
- **Succeeded**  
    All containers terminated normally (usually for Job workloads).
- **Failed**  
    A container terminated with a non-zero exit code.
- **Unknown**  
    The kubelet can’t report Pod status (node down, network issue, etc).

---

# 🧬 5. Pod Lifecycle Hooks (preStop & postStart)

Pods support lifecycle hooks to run actions inside containers at specific times.

### 🔹 postStart

Runs **right after** a container starts.

Uses:

- Registering service
- Seeding caches
- Custom logs
- Initial configuration

### 🔹 preStop

Runs **before the container receives SIGTERM**.

Uses:

- Graceful shutdown
- Draining traffic (for apps behind Services)
- Flushing logs
- Cleanup tasks

---

# 🧱 6. Container Lifecycle States

Containers inside Pods have their own lifecycle:

```
waiting → running → terminating
```

### Waiting
Container is preparing to run (pulling image, waiting for init containers, etc.)
### Running
Container is active and running.
### Terminating
The container is shutting down because:

- Pod is being deleted
- Liveness/readiness check failed
- Restart policy triggered

---

# ⚙️ Relationships Between Objects

Pod → created from Pod Template  
Pod Template → lives inside:

- Deployment
- ReplicaSet
- StatefulSet
- DaemonSet
- Job / CronJob

Static Pod → created directly by [[Kubelet]]

Containers → live inside Pods  
Init Containers → run before regular containers

---

# 🧩 7. Namespaces — Virtual Clusters Inside a Cluster

A **Namespace** is a virtual cluster inside the real Kubernetes cluster. It logically groups workloads, policies, and resources — but does **not** provide full security isolation.

Namespaces help you separate **teams**, **environments**, or **applications**.

### Why Namespaces Exist

- Organize cluster workloads
- Apply resource limits per group
- Apply RBAC per namespace
- Prevent name conflicts
- Scope of most Kubernetes objects lives _inside_ a namespace

---

## 🔹 Default & Reserved Namespaces

Kubernetes ships with important default namespaces:

|Namespace|Purpose|
|---|---|
|`default`|Where things go if no namespace is specified|
|`kube-system`|System components (kube-dns, coredns, scheduler, proxy, etc.)|
|`kube-node-lease`|Node heartbeats; improves performance|
|`kube-public`|Publicly readable config, used rarely|
|`kube-*`|Reserved — don’t deploy your apps here|

---

# 🧩 8. Resource Quota & Limit Range

Namespaces can have **resource boundaries** so teams don’t kill each other.

## 🔹 ResourceQuota

Controls **how many resources** a namespace may consume:

- Max pods
- Max CPU / RAM
- Max PVCs
- Max services
- Max load balancers

**Example:**
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-a-quota
  namespace: team-a
spec:
  hard:
    pods: "30"
    requests.cpu: "10"
    limits.memory: "32Gi"
```

---

## 🔹 LimitRange

Defines **default**, **min**, and **max** CPU/memory per pod or container.

Kubernetes **does NOT enforce resource limits** unless you define them.

**Example:**
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: dev
spec:
  limits:
    - type: Container
      default:
        cpu: "500m"
        memory: "256Mi"
      max:
        cpu: "2"
        memory: "1Gi"
      min:
        cpu: "50m"
        memory: "64Mi"

```

---

# 🏷️ 9. Labels & Selectors

Labels are **key=value** pairs used to identify and group objects.

Used by:

- Services → select Pods
- Deployments → manage Pods
- Monitoring tools → filtering
- CI/CD → environment tagging

Selectors match labels to connect objects:

```yaml
metadata:
  labels:
    app: myapp
---
spec:
  selector:
    matchLabels:
      app: myapp

```

You cannot operate Kubernetes efficiently without labels.

---

# 📝 10. Annotations

Annotations are **metadata for humans or tools**.

They do **not** affect scheduling or selection.

Uses:

- Document configs
- Add instructions for CI/CD
- Add notes for future devs
- Tool hints (Istio, cert-manager, ArgoCD, etc.)

**Example:**
```yaml
metadata:
  annotations:
    owner: sina
    description: "Handles authentication services"
```

---

# 🔐 11. Finalizers — Prevent Accidental Deletion

A **finalizer** blocks an object from being deleted until certain cleanup happens.

Used to avoid human mistakes.

**Example:**
```yaml
metadata:
  finalizers:
    - protect.kubernetes.io/no-delete
```
Until the finalizer is removed, the object stays in `Terminating`.

---

# ⚙️ 12. How These Objects Fit Together

This is the relationships context that ties your notes neatly:

- **Namespaces** group and restrict objects
- **ResourceQuota / LimitRange** apply consumption limits
- **Labels & selectors** connect objects together
- **Annotations** make objects understandable
- **Finalizers** prevent catastrophic deletion
- **Pods** run your actual applications
- **Pod templates** define how Pods are recreated
- **Controllers** (Deployments, RS, DS, etc.) use templates
- **Static Pods** bypass the control plane
- **Lifecycle hooks** and **container states** describe behavior

Everything is connected and depends on these foundational concepts.