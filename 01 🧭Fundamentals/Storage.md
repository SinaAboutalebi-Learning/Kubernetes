Kubernetes storage is designed to persist data for applications, enable shared storage across Pods, and provide flexible storage provisioning across different environments (cloud, bare-metal, hybrid).

K8s storage abstracts underlying storage systems (local disk, NFS, Ceph, cloud storage, SAN, etc.) and makes them portable and manageable through APIs.

---

# 🗃️ 1. Volumes in Kubernetes

Kubernetes Volumes are attached to **Pods**, not containers.  
Volumes outlive containers **inside a Pod**, but NOT the Pod itself.

### Why Volumes?

- Persist data across container restarts
- Share data between multiple containers in a Pod
- Provide external, durable storage for stateful apps

---

# 📦 2. HostPath (NOT Best Practice)

Maps a **host directory** → into a **Pod directory**.

### ⚠️ Issues:

- No isolation (huge security hole)
- Coupled to node → not portable
- Breaking scheduling (Pod can run only on that node)
- Risk of exposing sensitive host paths

Use **OPA Gatekeeper** or Admission Controllers to block HostPath in production.

**Use Cases (Rare):**

- Kubelet logs
- Local testing
- Monitoring agents

---

# ⚡ 3. Ephemeral Storage

Temporary storage that exists only during the Pod lifetime.

Used for:

- Caching
- Temporary files
- Scratch space

When the Pod is deleted → **storage is destroyed**.

Types:

- `emptyDir`
- `configMap`
- `secret`
- `downwardAPI`
- `ephemeral volumes` from CSI

---

# 🗄️ 4. Persistent Volumes (PV)

A **cluster-wide resource** (created by Admin).

Describes:

- Storage type (NFS, Ceph, AWS EBS, vSphere, etc.)
- Capacity
- Access modes
- Reclaim policy
- Storage class

PV is like a **physical disk** in Kubernetes terms.

---

# 📥 5. Persistent Volume Claims (PVC)

A **user request** for storage.

It requests:

- Size
- Access mode
- Storage class

A PVC binds to a matching PV (manual provisioning)  
OR triggers a StorageClass to create one automatically (dynamic provisioning).

---

# ⚙️ 6. StorageClass (Dynamic Provisioning)

Automates creation of PVs when a PVC is created.

The controller backs the PVC using:

- Cloud storage (EBS, GCE PD)
- Ceph RBD / CephFS
- NFS provisioner
- vSphere
- Any CSI-supported storage

This is called **dynamic provisioning**.

---

# 🔑 7. Access Modes

|Mode|Meaning|Type|
|---|---|---|
|**RWO (ReadWriteOnce)**|Only 1 node can mount the volume (typically block storage)|Block|
|**RWX (ReadWriteMany)**|Many nodes/pods can read & write (shared FS)|Shared|
|**ROX (ReadOnlyMany)**|Many nodes can read|Block|

### Notes:

- `RWX` → needed for shared storage like NFS, CephFS
- `RWO` → common for EBS-like disks
- `ROX` → used for cloned or read-only data

---

# 🔁 8. PV & PVC Phases

### **PV Phases**

- `Available`
- `Bound`
- `Released`
- `Failed`

### **PVC Phases**

- `Pending`
- `Bound`
- `Lost`

---

# 📸 9. Volume Snapshots (CSI Snapshot API)

Volume snapshots allow:

- Backups
- Cloning
- Disaster recovery
- Point-in-time recovery

### Snapshot Concepts:

|Component|Acts Like|Description|
|---|---|---|
|**VolumeSnapshot**|PVC|User request for a snapshot|
|**VolumeSnapshotContent**|PV|Actual snapshot data|
|**VolumeSnapshotClass**|StorageClass|Defines snapshot driver and parameters|

Snapshots require **CSI-based storage providers**.

---

# 🧰 10. Summary

✔ Pod-attached volumes make containers stateless
✔ Persistent Volumes (PV) are admin-defined
✔ Persistent Volume Claims (PVC) are user requests
✔ StorageClass automates PV creation
✔ Ephemeral storage is temporary
✔ Access modes define multi-node capabilities
✔ Snapshots allow backups & cloning

---

# 🔗 Internal Links

Related Topics: 
- [[StatefulSet]] 
- [[DaemonSet]] 
- [[CNI]] 
- [[CRI]] 
- [[CSI]] 
- [[Kubernetes Objects]] 
