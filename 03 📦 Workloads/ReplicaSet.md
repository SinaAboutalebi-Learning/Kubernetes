**Purpose:** Ensures a specific **number of Pod replicas** are always running.

- It creates Pods based on a **pod template**.
- Tracks Pods using **labels & selectors**.
- Will restart/replace Pods if they disappear.

ReplicaSet is rarely used directly — it is managed automatically by **[[Deployment]]**.

### Use Cases

- Workloads that need stable, identical Pods.
- Not used for advanced updates → Deployments replace them.

**Relationship:**  
ReplicaSet → manages Pods  
Deployment → manages ReplicaSets