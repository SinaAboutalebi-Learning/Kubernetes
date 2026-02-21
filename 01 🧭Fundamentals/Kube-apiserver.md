The **API Server** is the _front door_ of the Kubernetes control plane.

Everything — kubectl, controllers, nodes, operators — _must_ go through the API server.  
No component talks directly to etcd except the API server.

---

# ⭐ Key Characteristics

### **1. Stateless**

API servers don’t store any internal state — they only read/write to etcd.

### **2. Horizontally Scalable**

You can run multiple API server replicas behind a load balancer.  
This is called **active-active** (all serve traffic simultaneously).

### **3. Single Source of Truth Access**

Every operation in Kubernetes goes like:

`client → API server → etcd → API server → other components`

No exceptions.

---

# 🧭 The API Server Flow

This is the flow when something hits the API server, e.g.:

> `kubectl apply -f deployment.yaml`

Each request goes through these stages:

```
Request
    ↓ 
Authentication
    ↓ 
Authorization (RBAC)
    ↓ 
Admission Controllers (Mutating & Validating)
	↓ 
Validation of schema (OpenAPI)
    ↓ 
Retrieve current state from etcd
    ↓ 
Compare desired vs existing 
    ↓ 
Write updated state to etcd
    ↓ 
Notify controllers (Scheduler, Controller-Manager)
    ↓ 
Controllers reconcile
    ↓ 
kubelet pulls assigned pods
```

Let’s break it down more visually.

---

# 🖼 Detailed Diagram — API Server Request Lifecycle

```
                            +---------------------------+
Client (kubectl, UI, etc.)  | kubectl / client-go / API |
             |              +-------------+-------------+
             |                            |
             v                            v
      +------------------------------------------+
      |              kube-apiserver              |
      +------------------------------------------+
             |         |        |        |
             |         |        |        |
             v         v        v        v
     [1] Authentication (certs, tokens, OIDC)
     [2] Authorization (RBAC, ABAC, Node)
     [3] Admission Controllers
         - Mutating Webhooks
         - Validating Webhooks
     [4] Schema Validation (OpenAPI models)
             |
             v
      +---------------------------+
      |   Read current object    |
      |        from etcd         |
      +---------------------------+
             |
             v
      +---------------------------+
      |   Write new/updated       |
      |      object to etcd       |
      +---------------------------+
             |
             v
      +---------------------------+
      | Controllers get notified  |
      | (Scheduler, CM, etc.)     |
      +---------------------------+
             |
             v
      +---------------------------+
      |     kubelet receives      |
      |      assigned workload     |
      +---------------------------+

```
---
# 🔍 Breakdown of Each Stage

### **1. Authentication**

How Kubernetes knows **who** you are.  
Methods:

- Client certificates (CKA-style clusters)
- Bearer tokens
- ServiceAccounts
- OIDC (Google, Keycloak, Azure AD)
    

Links:  
→ [[Kubeconfig and AccessModel]]
→ [[Certificates]]

---

### **2. Authorization (RBAC)**

After confirming identity, it checks:  
“Is this user allowed to do this action?”

Using RBAC:

`Role/ClusterRole → RoleBinding/ClusterRoleBinding → Subjects`

Links:  
→ [[RBAC]]

---

### **3. Admission Controllers**

Before persisting the object, Kubernetes applies policies such as:

- `NamespaceLifecycle`
- `LimitRanger`
- `ResourceQuota`
- `PodSecurity`
- Webhooks (OPA Gatekeeper, Kyverno)

Mutating webhooks can rewrite your manifests before storing them.

---

### **4. Validation**

The API server validates objects against the schema defined in the Kubernetes OpenAPI spec.

---

### **5. etcd Read & Write**

Everything ends in etcd.  
If etcd doesn’t commit → the API server fails the request.

Link:  
→ [[etcd]]

---

### **6. Scheduler Notification**

If a new pod is created:

- The API server writes the pod spec _without_ a node assignment
- Scheduler watches API changes
- Scheduler picks a node
- Writes back the node assignment
- kubelet on that node starts the pod

Links:  
→ [[Control Plane]]

---
# 🧪 Pod Creation Full Flow

```
kubectl apply
     ↓
API server (auth → RBAC → admission → validation)
     ↓
etcd stores “Pod needs scheduling”
     ↓
Scheduler detects unscheduled pod
     ↓
Scheduler assigns NodeX → writes back to etcd
     ↓
API server notifies kubelet@NodeX
     ↓
kubelet pulls image + creates containers
     ↓
Pod is Running
```
